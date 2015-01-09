require 'dfp_api'
require 'dfp_api_statement'
require 'pry'


API_VERSION = :v201411
RATE_CARD = "DALAI_Test Ratecard"
PRODUCT_TEMPLATE = "Boxbanner Standard_RON_Basic"
WORKFLOW = "DALAI_Test Workflow"
AGENCY_COMPANY = "DALAI_Test Agency"
ADVERTISER_COMPANY = "DALAI_Test Advertiser"
PROPOSAL = "DALAI_Test Proposal"
ORDER = "DALAI_Test Order"
TEAM = "DALAI_Test Team"
ADVERTISER_CONTACT = 'dvaldez@dalai.com'
AGENCY_CONTACT = 'gerardo@dalai.com'

class Connection
  attr_accessor :dfp

  def initialize
    puts "Initialize"
    config_filename = File.join('dfp_api.yml')
    @dfp = DfpApi::Api.new(config_filename)
  end

  def network_service
    network_service = @dfp.service(:NetworkService, API_VERSION)
    network = network_service.make_test_network
  end

  # Dummy example: Prints all ad units
  def statement_service
    inventory_service = @dfp.service(:InventoryService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new('ORDER BY id ASC')

    begin
      # Get ad units by statement.
      page = inventory_service.get_ad_units_by_statement(statement.toStatement())

      if page[:results]
        # Print details about each ad unit in results.
        page[:results].each_with_index do |ad_unit, index|
          puts "%d) Ad unit ID: %d, name: %s, status: %s." %
              [index + statement.offset, ad_unit[:id],
               ad_unit[:name], ad_unit[:status]]
        end
      end
      statement.offset += DfpApiStatement::SUGGESTED_PAGE_LIMIT
    end while statement.offset < page[:total_result_set_size]

    # Print a footer.
    if page.include?(:total_result_set_size)
      puts "Total number of ad units: %d" % page[:total_result_set_size]
    end
  end

  # Get all companies
  def company_service
    service = @dfp.service(:CompanyService, API_VERSION)

    # Create a statement to select all companies.
    statement = DfpApiStatement::FilterStatement.new('ORDER BY id ASC')
    begin
      page = service.get_companies_by_statement(statement.toStatement())

      if page[:results]
        page[:results].each_with_index do |company, index|
          puts "%d) Company ID: %d, name: '%s', type: '%s'" % [index + statement.offset, company[:id], company[:name], company[:type]]
        end
      end
      statement.offset += DfpApiStatement::SUGGESTED_PAGE_LIMIT
    end while statement.offset < page[:total_result_set_size]

    # Print a footer.
    if page.include?(:total_result_set_size)
      puts "Total number of companies: %d" % page[:total_result_set_size]
    end
  end

  # Searches for dalai advertiser company based on a hardcoded name
  def get_dalai_advertiser_company
    company_service = @dfp.service(:CompanyService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new("WHERE name = '#{ADVERTISER_COMPANY}' AND type = 'ADVERTISER'")
    page = company_service.get_companies_by_statement(statement.toStatement)
    if page[:results]
      puts "%d) Company ID: %d, name: '%s'" % [statement.offset + 1, page[:results].first[:id], page[:results].first[:name]]
    end
  end

  # Searchs for dalai agency company based on a harcoded name
  def get_dalai_agency_company
    company_service = @dfp.service(:CompanyService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new("WHERE name ='#{AGENCY_COMPANY}' AND type = 'AGENCY'")
    page = company_service.get_companies_by_statement(statement.toStatement)
    if page[:results]
      puts "%d) Company ID: %d, name: '%s'" % [statement.offset + 1, page[:results].first[:id], page[:results].first[:name]]
    end
  end

  # Get all the teams
  def teams_service
    service = @dfp.service(:TeamService, API_VERSION)

    # Create a statement to select all companies.
    statement = DfpApiStatement::FilterStatement.new('ORDER BY id ASC')
    begin
      page = service.get_teams_by_statement(statement.toStatement())

      if page[:results]
        page[:results].each_with_index do |company, index|
          puts "%d) Team ID: %d, name: '%s'" % [index + statement.offset, company[:id], company[:name]]
        end
      end
      statement.offset += DfpApiStatement::SUGGESTED_PAGE_LIMIT
    end while statement.offset < page[:total_result_set_size]

    # Print a footer.
    if page.include?(:total_result_set_size)
      puts "Total number of teams: %d" % page[:total_result_set_size]
    end
  end

  # Searches for an specific dalai team based on a harcoded name
  def get_dalai_team
    team_service = @dfp.service(:TeamService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new("WHERE name = '#{TEAM}'")
    page = team_service.get_teams_by_statement statement.toStatement

    if page[:results]
      puts "%d) Team id: %d, name: '%s'" % [statement.offset + 1, page[:results].first[:id], page[:results].first[:name]]
    end
  end

  # Get specific contact based on email
  def contacts_service
    service = @dfp.service(:ContactService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new("WHERE email = '#{ADVERTISER_CONTACT}'")
    page = service.get_contacts_by_statement statement.toStatement

    if page[:results]
      puts "%d) Contact id: %d, name: '%s', company_id: '%s'" % [statement.offset + 1, page[:results].first[:id], page[:results].first[:name], page[:results].first[:company_id]]
    end
  end

  def get_contact_by_id contact_id
    service = @dfp.service(:ContactService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new("WHERE id = '#{contact_id}'")
    page = service.get_contacts_by_statement statement.toStatement

    if page[:results]
      puts "%d) Contact id: %d, name: '%s', company_id: '%s'" % [statement.offset + 1, page[:results].first[:id], page[:results].first[:name], page[:results].first[:company_id]]
    end
  end

  # Searches for contacts in companies
  def get_contacts_in_company
    service = @dfp.service(:ContactService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new("WHERE companyId = 565817683")
    page = service.get_contacts_by_statement statement.toStatement
    if page[:results]
      puts "%d) Contact id: %d, name: '%s', company_id: '%s'" % [statement.offset + 1, page[:results].first[:id], page[:results].first[:name], page[:results].first[:company_id]]
    end
  end

  def get_user_by_id user_id
    service = @dfp.service(:UserService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new("WHERE id = '#{user_id}'")
    page = service.get_users_by_statement statement.toStatement

    if page[:results]
      puts "%d) User id: %d, name: '%s" % [statement.offset + 1, page[:results].first[:id], page[:results].first[:name]]
    end
  end

  # Searches for an specific dalai order based on a hardcoded name
  def get_dalai_order
    order_service = @dfp.service(:OrderService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new("WHERE name = '#{ORDER}' AND status = 'APPROVED'")
    page = order_service.get_orders_by_statement statement.toStatement
    if page[:results]
      puts "%d) Order ID: %d, name: '%s', status: '%s'" % [statement.offset + 1, page[:results].first[:id], page[:results].first[:name], page[:results].first[:status]]
    end
  end

  # Gets all proposals
  def proposal_service
    service = @dfp.service(:ProposalService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new("ORDER by id ASC")
    begin
      page = service.get_proposals_by_statement statement.toStatement

      if page[:results]
        page[:results].each_with_index do |proposal, index|
          puts "%d) Proposal ID: %d, name: '%s', status: '%s'" % [index + statement.offset, proposal[:id], proposal[:name], proposal[:status]]
        end
      end
      statement.offset += DfpApiStatement::SUGGESTED_PAGE_LIMIT
    end while statement.offset < page[:total_result_set_size]

    # Print a footer.
    if page.include?(:total_result_set_size)
      puts "Total number of companies: %d" % page[:total_result_set_size]
    end
  end

  # Search for dalai specific proposal based on a hardcoded name
  def get_dalai_proposal
    proposal_service = @dfp.service(:ProposalService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new("WHERE name = '#{PROPOSAL}' AND status = 'DRAFT'")
    page = proposal_service.get_proposals_by_statement statement.toStatement

    if page[:results]
      puts "%d) Proposal ID: %d, name: '%s', status: '%s'" % [statement.offset + 1, page[:results].first[:id], page[:results].first[:name], page[:results].first[:status]]
    end
  end

  # Get all ratecards
  def ratecard_service
    service = @dfp.service(:RateCardService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new("ORDER BY id ASC")
    page = service.get_rate_cards_by_statement(statement.toStatement())
    if page[:results]
      page[:results].each_with_index do |ratecard, index|
        puts "%d) Ratecard ID: %d, name: '%s'" % [index + statement.offset, ratecard[:id], ratecard[:name]]
      end
    end

    if page.include?(:total_result_set_size)
      puts "Total number of rate cards: %d" % page[:total_result_set_size]
    end
  end

  # Searches for dalai ratecard based on a harcoded name
  def get_dalai_ratecard
    service = @dfp.service(:RateCardService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new("WHERE name = '#{RATE_CARD}'")
    page = service.get_rate_cards_by_statement(statement.toStatement())
    if page[:results]
      puts "%d) Ratecard ID: %d, name: '%s'" % [statement.offset + 1, page[:results].first[:id], page[:results].first[:name]]
    end
  end

  # Get workflow service
  def workflow_service
    service = @dfp.service(:WorkflowRequestService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new("WHERE type = 'WORKFLOW_APPROVAL_REQUEST' AND status = 'APPROVED' ORDER BY id ASC")
    page = service.get_workflow_requests_by_statement(statement.toStatement())
    if page[:results]
      page[:results].each_with_index do |workflow, index|
        puts "%d) Workflow ID: %d, name: '%s'" % [index + statement.offset, workflow[:id], workflow[:workflow_rule_name]]
      end
    end

    if page.include?(:total_result_set_size)
      puts "Total number of workflows: %d" % page[:total_result_set_size]
    end
  end

  # Searches for dalai workflow baed on a harcoded name
  def get_dalai_workflow
    service = @dfp.service(:WorkflowRequestService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new("WHERE id = 643 AND type = 'WORKFLOW_APPROVAL_REQUEST'")
    page = service.get_workflow_requests_by_statement(statement.toStatement())
    if page[:results]
      puts "%d) Workflow ID: %d, name: '%s'" % [statement.offset + 1, page[:results].first[:id], page[:results].first[:workflow_rule_name]]
    end
  end

  # Get all product templates
  def product_template_service
    service = @dfp.service(:ProductTemplateService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new
    page = service.get_product_templates_by_statement(statement.toStatement())

    if page[:results]
      page[:results].each_with_index do |product_template, index|
        puts "%d) Product Template: %d, name: '%s'" % [index + statement.offset, product_template[:id], product_template[:name]]
      end
    end
    if page.include?(:total_result_set_size)
      puts "Total number of product templates: %d" % page[:total_result_set_size]
    end
  end

  # Search for dalai product template based on a harcoded name
  def get_dalai_product_template
    service = @dfp.service(:ProductTemplateService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new("WHERE name = '#{PRODUCT_TEMPLATE}'")
    page = service.get_product_templates_by_statement(statement.toStatement())
    if page[:results]
      puts "%d) Product Template ID: %d, name: '%s'" % [statement.offset + 1, page[:results].first[:id], page[:results].first[:name]]
    end
  end

  # Search products based on a harcoded product_template_id
  def get_products
    product_service = @dfp.service(:ProductService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new("WHERE productTemplateId = #{44683}")
    page = product_service.get_products_by_statement(statement.toStatement())
    if page[:results]
      puts "%d) Product ID: %d, name: '%s'" % [statement.offset + 1, page[:results].first[:id], page[:results].first[:name]]
    end
  end
end
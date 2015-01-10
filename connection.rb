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
end
require 'dfp_api'
require 'dfp_api_statement'
require 'pry'


API_VERSION = :v201411

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

  def get_all_companies
    company_service = @dfp.service(:CompanyService, API_VERSION)

    # Create a statement to select all companies.
    statement = DfpApiStatement::FilterStatement.new('ORDER BY id ASC')
    begin
      # Get companies by statement.
      page = company_service.get_companies_by_statement(statement.toStatement())

      if page[:results]
        page[:results].each_with_index do |company, index|
          puts "%d) Company ID: %d, name: '%s', type: '%s'" %
              [index + statement.offset,
               company[:id], company[:name], company[:type]]
        end
      end
      statement.offset += DfpApiStatement::SUGGESTED_PAGE_LIMIT
    end while statement.offset < page[:total_result_set_size]

    # Print a footer.
    if page.include?(:total_result_set_size)
      puts "Total number of companies: %d" % page[:total_result_set_size]
    end
  end

  def product_template_service
    product_template_service = @dfp.service(:ProductTemplateService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new("WHERE id = #{44683}")
    page = product_template_service.get_product_templates_by_statement(statement.toStatement())
    if page.include?(:total_result_set_size)
      puts "Total number of product templates: %d" % page[:total_result_set_size]
    end
  end

  def product_service
    product_service = @dfp.service(:ProductService, API_VERSION)
    statement = DfpApiStatement::FilterStatement.new("WHERE id = #{1934443}")
    page = product_service.get_products_by_statement(statement.toStatement())

    if page.include?(:total_result_set_size)
      puts "Total number of products: %d" % page[:total_result_set_size]
    end
  end
end
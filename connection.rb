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
    inventory_service = dfp.service(:InventoryService, API_VERSION)
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
end




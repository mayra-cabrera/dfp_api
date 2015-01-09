require_relative 'base.rb'

class Company < Base
  ADVERTISER = "ADVERTISER"
  AGENCY = "AGENCY"
  attr_accessor :service

  def initialize
    super
    @service = generate_service "CompanyService"
  end

  def get_all
    api_statement = generate_statement 
    begin
      page = @service.get_companies_by_statement api_statement.toStatement

      if page[:results]
        page[:results].each_with_index do |company, index|
          puts "%d) Company ID: %d, name: '%s', type: '%s'" % [index + api_statement.offset, company[:id], company[:name], company[:type]]
        end
      end
      api_statement.offset += DfpApiStatement::SUGGESTED_PAGE_LIMIT

    end while api_statement.offset < page[:total_result_set_size]

    print_footer page
  end

  def get_advertiser_company_by_name name = nil
    name ||= "DALAI_Test Advertiser"
    api_statement = generate_statement "WHERE name = '#{name}' AND type = '#{ADVERTISER}'"
    page = @service.get_companies_by_statement api_statement.toStatement

    print_result page[:results].first, api_statement
  end

  def get_agency_company_by_name name = nil
    name ||= "DALAI_Test Agency"
    api_statement = generate_statement "WHERE name = '#{name}' AND type = '#{AGENCY}'"
    page = @service.get_companies_by_statement api_statement.toStatement

    print_result page[:results].first, api_statement
  end

  private

  def print_result results, statement
    if results
      puts "%d) Company ID: %d, name: '%s'" % [statement.offset + 1, results[:id], results[:name]]
    end
  end
end
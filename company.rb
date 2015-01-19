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
      print_results page[:results] if page[:results]
      api_statement.offset += DfpApiStatement::SUGGESTED_PAGE_LIMIT
    end while api_statement.offset < page[:total_result_set_size]

    print_footer page
  end

  def find_advertiser_by_id company_id
    api_statement = generate_statement "WHERE id = '#{company_id}' AND type = '#{ADVERTISER}'"
    page = @service.get_companies_by_statement api_statement.toStatement

    print_results page[:results] if page[:results]
  end

  def find_agency_by_id company_id
    api_statement = generate_statement "WHERE id = '#{company_id}' AND type = '#{AGENCY}'"
    page = @service.get_companies_by_statement api_statement.toStatement

    print_results page[:results] if page[:results]
  end

  private

  def print_results results
    results.each do |company|
      puts "- Company ID: %d, name: '%s'" % [company[:id], company[:name]]
    end
  end
end
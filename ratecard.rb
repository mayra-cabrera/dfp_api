require_relative "base.rb"

class RateCard < Base
  attr_accessor :service

  def initialize
    super
    @service = generate_service "RateCardService"
  end

  def get_all
    api_statement = generate_statement 
    page = @service.get_rate_cards_by_statement api_statement.toStatement

    if page[:results]
      page[:results].each_with_index do |ratecard, index|
        puts "%d) Ratecard ID: %d, name: '%s'" % [index + api_statement.offset, ratecard[:id], ratecard[:name]]
      end
    end

    print_footer page
  end

  def find_by_name name = nil
    name ||= "DALAI_Test Ratecard"
    api_statement = generate_statement "WHERE name = '#{name}'"
    page = @service.get_rate_cards_by_statement api_statement.toStatement

    print_results page[:results].first, api_statement
  end

  private

  def print_results results, statement
    if results
      puts "%d) Ratecard ID: %d, name: '%s'" % [statement.offset + 1, results[:id], results[:name]]
    end
  end
end
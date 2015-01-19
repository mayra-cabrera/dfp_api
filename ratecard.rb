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

    print_results page[:results] if page[:results]
    print_footer page
  end

  def find_by_id rate_card_id
    api_statement = generate_statement "WHERE id = '#{rate_card_id}'"
    page = @service.get_rate_cards_by_statement api_statement.toStatement

    print_results page[:results] if page[:results]
    print_footer page
  end

  private

  def print_results results
    results.each_with_index do |rate_card, index|
      puts "%d) Ratecard ID: %d, name: '%s'" % [index + 1, rate_card[:id], rate_card[:name]]
    end
  end
end
require_relative 'base.rb'

class Order < Base
  APPROVED = "APPROVED"
  attr_accessor :service

  def initialize
    super
    @service = generate_service "OrderService"
  end

  def find_approved_order_by_name name = nil
    name ||= "DALAI_Test Order"
    api_statement = generate_statement "WHERE name = '#{name}'"
    page = @service.get_orders_by_statement api_statement.toStatement

    print_results page[:results], api_statement
  end

  def find_order_by_ids
    api_statement = generate_statement "WHERE id IN (243342883, 244273363)"
    page = @service.get_orders_by_statement api_statement.toStatement

    print_results page[:results], api_statement
  end

  private

  def print_results results, statement
    return unless results
    results.each_with_index do |result, index|
      puts "%d) Order ID: %d, name: '%s', status: '%s'" % [statement.offset + index, result[:id], result[:name], result[:status]]
    end
  end
end

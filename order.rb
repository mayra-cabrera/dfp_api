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
    api_statement = generate_statement "WHERE name = '#{name}' AND status = '#{APPROVED}'"
    page = @service.get_orders_by_statement api_statement.toStatement

    print_results page[:results].first, api_statement
  end

  private

  def print_results results, statement
    if results
      puts "%d) Order ID: %d, name: '%s', status: '%s'" % [statement.offset + 1, results[:id], results[:name], results[:status]]
    end
  end
end

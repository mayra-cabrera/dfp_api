require_relative 'base.rb'

class Order < Base
  APPROVED = "APPROVED"
  attr_accessor :service

  def initialize
    super
    @service = generate_service "OrderService"
  end

  def find_approved_by_id order_id
    api_statement = generate_statement "WHERE id = '#{order_id}'"
    page = @service.get_orders_by_statement api_statement.toStatement

    print_results page[:results] if page[:results]
  end

  # The first one is approved, the last one is draft
  def find_by_multiple_ids
    api_statement = generate_statement "WHERE id IN (243342883, 244273363)"
    page = @service.get_orders_by_statement api_statement.toStatement

    print_results page[:results] if page[:results]
  end

  private

  def print_results results
    results.each_with_index do |order, index|
      puts "%d) Order ID: %d, name: '%s', status: '%s'" % [index + 1, order[:id], order[:name], order[:status]]
    end
  end
end

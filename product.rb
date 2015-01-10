require_relative 'base.rb'

class Product < Base
  attr_accessor :service

  def initialize
    super
    @service = generate_service "ProductService"
  end

  # 44683
  def find_by_product_template_id product_template_id
    api_statement = generate_statement "WHERE productTemplateId = #{product_template_id}"
    page = @service.get_products_by_statement api_statement.toStatement

    print_results page[:results].first, api_statement
  end

  private

  def print_results results, statement
    if results
      puts "%d) Product ID: %d, name: '%s'" % [statement.offset + 1, results[:id], results[:name]]
    end
  end
end
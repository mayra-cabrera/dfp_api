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

    print_results page[:results] if page[:results]
    print_footer page
  end

  private

  def print_results results
    results.each_with_index do |product, index|
      puts "%d) Product ID: %d, name: '%s'" % [index + 1, product[:id], product[:name]]
    end
  end
end
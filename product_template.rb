require_relative 'base.rb'

class ProductTemplate < Base
  attr_accessor :service

  def initialize
    super
    @service = generate_service "ProductTemplateService"
  end

  def get_all
    api_statement = generate_statement
    page = @service.get_product_templates_by_statement api_statement.toStatement
    print_results page[:results] if page[:results]
    print_footer page
  end

  def find_by_name name = nil
    name ||= "Boxbanner Standard_RON_Basic"
    api_statement = generate_statement "WHERE name = '#{name}'"
    page = @service.get_product_templates_by_statement api_statement.toStatement
    print_results page[:results] if page[:results]
  end

  private

  def print_results results
    results.each_with_index do |product_template, index|
      puts "%d) Product Template: %d, name: '%s'" % [index + 1, product_template[:id], product_template[:name]]
    end
  end
end
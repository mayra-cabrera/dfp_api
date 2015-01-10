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
    if page[:results]
      page[:results].each_with_index do |product_template, index|
        puts "%d) Product Template: %d, name: '%s'" % [index + api_statement.offset, product_template[:id], product_template[:name]]
      end
    end

    print_footer page
  end

  def find_by_name name = nil
    name ||= "Boxbanner Standard_RON_Basic"
    api_statement = generate_statement "WHERE name = '#{name}'"
    page = @service.get_product_templates_by_statement api_statement.toStatement
    print_result page[:results].first, api_statement
  end

  private

  def print_result results, statement
    if results
      puts "%d) Product Template ID: %d, name: '%s'" % [statement.offset + 1, results[:id], results[:name]]
    end
  end
end
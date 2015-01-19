require_relative 'base.rb'

class CustomField < Base
  attr_accessor :service
  INDUSTRY = 2803
  PRODUCT_TYPE  = 3523
  UDN_ASSIGN = 5323

  def initialize
    super
    @service = generate_service "CustomFieldService"
  end

  # Searches a custom field through ID
  def find id
    api_statement = generate_statement "WHERE id = #{id}"
    page = @service.get_custom_fields_by_statement api_statement.toStatement
    print_results page[:results].first, api_statement
  end

  # option_id = 2803
  def update id, option_id, new_value = nil
    new_value ||= "Test Dalai"
    custom_field_options = [{id: id, custom_field_id: option_id, display_name: new_value}]
    page = @service.update_custom_field_options custom_field_options
    find id
  end

  def print_results results, statement
    if results
      puts "%d) ID: %d, name: '%s', options: '%s'" % [statement.offset + 1, results[:id], results[:name], results[:options]]
    end
  end
end
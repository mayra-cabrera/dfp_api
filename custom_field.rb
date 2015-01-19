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
  def find_by_id id
    api_statement = generate_statement "WHERE id = #{id}"
    page = @service.get_custom_fields_by_statement api_statement.toStatement
    print_results page[:results] if page[:results]
  end

  # option_id = 2803
  def update id, option_id, new_value = nil
    new_value ||= "Test Dalai"
    custom_field_options = [{id: id, custom_field_id: option_id, display_name: new_value}]
    page = @service.update_custom_field_options custom_field_options
    find_by_id id
  end

  def print_results results
    results.each_with_index do |custom_field, index|
      puts "%d) ID: %d, name: '%s', options: '%s'" % [index + 1, custom_field[:id], custom_field[:name], custom_field[:options]]
    end
  end
end
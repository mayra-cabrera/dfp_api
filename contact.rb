require_relative 'base.rb'

class Contact < Base
  attr_accessor :service

  def initialize
    super
    @service = generate_service "ContactService"
  end

  def find_contact_by_email email = nil
    email ||= 'dvaldez@dalai.com'
    api_statement = generate_statement "WHERE email = '#{email}'"
    page = @service.get_contacts_by_statement api_statement.toStatement

    print_footer page[:results].first, api_statement
  end

  def find_contact_by_id contact_id
    api_statement = generate_statement "WHERE id = '#{contact_id}'"
    page = service.get_contacts_by_statement api_statement.toStatement

    print_footer page[:results].first, api_statement
  end

  def find_contacts_by_company_id company_id
    api_statement = generate_statement "WHERE companyId = #{company_id}"
    page = service.get_contacts_by_statement api_statement.toStatement

    print_footer page[:results].first, api_statement
  end

  private

  def print_footer results, statement
    if results
      puts "%d) Contact id: %d, name: '%s', company_id: '%s'" % [statement.offset + 1, results[:id], results[:name], results[:company_id]]
    end
  end
end
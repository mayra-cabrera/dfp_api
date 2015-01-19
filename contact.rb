require_relative 'base.rb'

class Contact < Base
  attr_accessor :service

  def initialize
    super
    @service = generate_service "ContactService"
  end

  def find_by_email email = nil
    email ||= 'dvaldez@dalai.com'
    api_statement = generate_statement "WHERE email = '#{email}'"
    page = @service.get_contacts_by_statement api_statement.toStatement

    print_results page[:results] if page[:results]
  end

  def find_by_id contact_id
    api_statement = generate_statement "WHERE id = '#{contact_id}'"
    page = service.get_contacts_by_statement api_statement.toStatement

    print_results page[:results] if page[:results]
  end

  def find_by_company_id company_id
    api_statement = generate_statement "WHERE companyId = #{company_id}"
    page = service.get_contacts_by_statement api_statement.toStatement

    print_results page[:results] if page[:results]
  end

  private

  def print_results results
    results.each_with_index do |contact, index|
      puts "%d) Contact id: %d, name: '%s', company_id: '%s'" % [index + 1, contact[:id], contact[:name], contact[:company_id]]
    end
  end
end
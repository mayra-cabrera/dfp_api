require_relative 'base.rb'

class User < Base
  attr_accessor :service
  TRAFFICKERS = 9643

  def initialize
    super
    @service = generate_service "UserService"
  end

  def find_by_id user_id
    api_statement = generate_statement "WHERE id = '#{user_id}'"
    page = @service.get_users_by_statement api_statement.toStatement

    print_results page[:results] if[:results]
    print_footer page
  end

  def find_by_role role_id
    api_statement = generate_statement "WHERE roleId = '#{role_id}'"
    page = @service.get_users_by_statement api_statement.toStatement

    print_results page[:results] if [:results]
    print_footer page
  end

  private

  def print_results results
    results.each_with_index do |user, index|
      puts "%d) User id: %d, name: '%s'" % [index + 1, user[:id], user[:name], user[:rolename]]
    end
  end
end
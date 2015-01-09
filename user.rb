require_relative 'base.rb'

class User < Base
  attr_accessor :service

  def initialize
    super
    @service = generate_service "UserService"
  end

  def find_user_by_id user_id
    api_statement = generate_statement "WHERE id = '#{user_id}'"
    page = @service.get_users_by_statement api_statement.toStatement

    print_footer page[:results].first, api_statement
  end

  private

  def print_footer results, statement
    if results
      puts "%d) User id: %d, name: '%s" % [statement.offset + 1, results[:id], results[:name]]
    end
  end
end
require_relative 'role.rb'

class Role < Base
  attr_accessor :service

  def initialize
    super
    @service = generate_service "RoleService"
  end

  def get_all
    api_statement = generate_statement 
  end
end
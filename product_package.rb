require_relative 'base.rb'

class ProductPackage < Base
  attr_accessor :service

  def initialize
    super
    @service = generate_service "ProductPackageService"
  end

  def get_all
    api_statement = generate_statement
  end

  def find_by_id
  end
end
require 'dfp_api'
require 'dfp_api_statement'
require 'pry'

class Base
  attr_accessor :dfp

  API_VERSION = :v201411

  def initialize
    config_filename = File.join('dfp_api.yml')
    @dfp = DfpApi::Api.new(config_filename)
  end

  def generate_service service
    @dfp.service(service.to_sym, API_VERSION)
  end

  def generate_statement query = nil
    query ||= 'ORDER BY id ASC'
    DfpApiStatement::FilterStatement.new(query)
  end

  def print_footer page
    if page.include?(:total_result_set_size)
      puts "Total number of companies: %d" % page[:total_result_set_size]
    end
  end
end
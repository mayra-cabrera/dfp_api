require 'dfp_api'
require 'pry'


API_VERSION = :v201411

class Connection
  attr_accessor :dfp

  def initialize
    puts "Initialize"
    config_filename = File.join('dfp_api.yml')
    @dfp = DfpApi::Api.new(config_filename)
  end

  def make
    network_service = @dfp.service(:NetworkService, API_VERSION)
    network = network_service.make_test_network
  end
end




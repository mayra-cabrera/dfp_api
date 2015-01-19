require_relative 'base.rb'

class Team < Base
  attr_accessor :service

  def initialize
    super
    @service = generate_service "TeamService"
  end

  def get_all
    api_statement = generate_statement
    begin
      page = @service.get_teams_by_statement api_statement.toStatement
      print_results page[:results] if page[:results]
      api_statement.offset += DfpApiStatement::SUGGESTED_PAGE_LIMIT
    end while api_statement.offset < page[:total_result_set_size]

    print_footer page
  end

  def find_by_id team_id = nil
    api_statement = generate_statement "WHERE id = '#{team_id}'"
    page = @service.get_teams_by_statement api_statement.toStatement
  
    print_results page[:results] if page[:results]
    print_footer page
  end

  private 

  def print_results results
    results.each_with_index do |team, index|
      puts "%d) Team id: %d, name: '%s'" % [index + 1, team[:id], team[:name]]
    end
  end
end
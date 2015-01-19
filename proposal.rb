require_relative 'base.rb'

class Proposal < Base
  DRAFT = "DRAFT"
  attr_accessor :service

  def initialize
    super
    @service = generate_service "ProposalService"
  end

  def get_all
    api_statement = generate_statement
    begin
      page = @service.get_proposals_by_statement api_statement.toStatement
      print_results page[:results] if page[:results]
      api_statement.offset += DfpApiStatement::SUGGESTED_PAGE_LIMIT
    end while api_statement.offset < page[:total_result_set_size]

    print_footer page
  end

  def find_by_id proposal_id
    api_statement = generate_statement("WHERE id = '#{proposal_id}'")
    page = @service.get_proposals_by_statement api_statement.toStatement

    print_results page[:results] if page[:results]
  end

  def find_by_status status = nil
    status ||= DRAFT
    api_statement = generate_statement("WHERE status = '#{status}'")
    page = @service.get_proposals_by_statement api_statement.toStatement

    print_results page[:results] if page[:results]
    print_footer page
  end

  private 

  def print_results results
    results.each_with_index do |proposal|
      puts "- Proposal ID: %d, name: '%s', status: '%s'" % [proposal[:id], proposal[:name], proposal[:status]]
    end
  end
end
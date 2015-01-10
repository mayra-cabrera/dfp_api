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

      if page[:results]
        page[:results].each_with_index do |proposal, index|
          puts "%d) Proposal ID: %d, name: '%s', status: '%s'" % [index + api_statement.offset, proposal[:id], proposal[:name], proposal[:status]]
        end
      end
      api_statement.offset += DfpApiStatement::SUGGESTED_PAGE_LIMIT
    end while api_statement.offset < page[:total_result_set_size]

    print_footer page
  end

  def find_by_name name = nil
    name ||= "DALAI_Test Proposal"
    api_statement = generate_statement("WHERE name = '#{name}'")
    page = @service.get_proposals_by_statement api_statement.toStatement

    print_results page[:results].first, api_statement
  end

  def find_by_status status = nil
    status ||= DRAFT
    api_statement = generate_statement("WHERE status = '#{status}'")
    page = @service.get_proposals_by_statement api_statement.toStatement

    print_results page[:results].first, api_statement
  end

  private 

  def print_results results, api_statement
    if results
      puts "%d) Proposal ID: %d, name: '%s', status: '%s'" % [api_statement.offset + 1, results[:id], results[:name], results[:status]]
    end
  end
end
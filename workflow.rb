require_relative 'base.rb'

class Workflow < Base
  attr_accessor :service
  PROPOSAL = "PROPOSAL"
  UNKNOWN = "UNKNOWN"

  def initialize
    super
    @service = generate_service "WorkflowRequestService"
  end

  # Type is not optional!
  # entity_id makes reference to the workflow itself
  # entityType might be PROPOSAL or UNKNOWN
  def get_all
    api_statement = generate_statement "WHERE type = 'WORKFLOW_APPROVAL_REQUEST' AND entityType = '#{PROPOSAL}'"
    begin
      page = @service.get_workflow_requests_by_statement api_statement.toStatement
   
      print_results page[:results] if page[:results]
      api_statement.offset += DfpApiStatement::SUGGESTED_PAGE_LIMIT
    end while api_statement.offset < page[:total_result_set_size]
    print_footer page
  end

  # 643 - Dalai
  def find_by_id workflow_id
    api_statement = generate_statement "WHERE id = #{workflow_id} AND type = 'WORKFLOW_APPROVAL_REQUEST'"
    page = @service.get_workflow_requests_by_statement api_statement.toStatement

    print_results page[:results].first if page[:results]
    print_footer
  end

  private

  def print_results results
    results.each do |workflow|
      puts "- Workflow ID: %d, name: '%s'" % [workflow[:id], workflow[:workflow_rule_name]]
    end
  end
end
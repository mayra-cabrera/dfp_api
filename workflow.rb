require_relative 'base.rb'

class Workflow < Base
  attr_accessor :service

  def initialize
    super
    @service = generate_service "WorkflowRequestService"
  end

  # Type is not optional!
  def get_all
    api_statement = generate_statement "WHERE type = 'WORKFLOW_APPROVAL_REQUEST' AND status = 'APPROVED'"
    page = @service.get_workflow_requests_by_statement api_statement.toStatement
    if page[:results]
      page[:results].each_with_index do |workflow, index|
        puts "%d) Workflow ID: %d, name: '%s'" % [index + api_statement.offset, workflow[:id], workflow[:workflow_rule_name]]
      end
    end

    print_footer page
  end

  # 643 - Dalai
  def find_by_id workflow_id
    api_statement = generate_statement "WHERE id = #{workflow_id} AND type = 'WORKFLOW_APPROVAL_REQUEST'"
    page = @service.get_workflow_requests_by_statement api_statement.toStatement

    print_results page[:results].first, api_statement
  end

  private

  def print_results results, statement
    if results
      puts "%d) Workflow ID: %d, name: '%s'" % [statement.offset + 1, results[:id], results[:workflow_rule_name]]
    end
  end
end
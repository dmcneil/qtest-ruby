module QTest
  class TestRun < QTest::Base
    attr_accessor :id, :release, :test_cycle, :project, :test_suite

    # Submit an execution log for the Test Run.
    #
    # @param opts [Hash]
    # @option status [Symbol] passed, failed, etc.
    # @return [Hash]
    def submit_test_log(opts = {})
      opts[:status] = client.execution_statuses(project: @project.id)
                            .select do |status|
                              status[:name].downcase.to_sym == opts[:status]
                            end.first

      client.submit_test_log(project: @project.id,
                             test_run: @id,
                             attributes: opts)
    end
  end
end

module QTest
  class TestRun < QTest::Base
    attr_accessor :id, :release, :test_cycle, :project, :test_suite

    def initialize(opts = {})
      @id = opts[:id]
      @release = opts[:release]
      @test_cycle = opts[:test_cycle]
      @project = opts[:project]
      @test_suite = opts[:test_suite]
    end

    # Submit an execution log for the Test Run.
    #
    # @return [Hash]
    def submit_test_log(opts = {})
      client.submit_test_log(project: @project.id,
                             test_run: @id,
                             attributes: opts)
    end
  end
end

module QTest
  class TestSuite < QTest::Base
    attr_accessor :id, :project, :test_cycle, :release

    def initialize(opts = {})
      @id = opts[:id]
      @project = opts[:project]
      @test_cycle = opts[:test_cycle]
      @release = opts[:release]
    end

    def test_runs
      test_runs = self.class.client.test_runs(project: @project.id,
                                              test_suite: @id) || []

      test_runs.map do |test_run|
        test_run.project = @project
        test_run.test_suite = self
        test_run.release = @release

        test_run
      end
    end
  end
end

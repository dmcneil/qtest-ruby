module QTest
  class TestCycle < QTest::Base
    attr_accessor :id, :project, :release

    def initialize(opts={})
      @id = opts[:id]
      @project = opts[:project]
      @release = opts[:release]
    end

    def test_run(opts={})
      test_run = self.class.client.test_run(project: @project.id,
                                            test_cycle: @id,
                                            id: opts[:id])

      if test_run
        test_run.project = @project
        test_run.test_cycle = self
      end

      test_run
    end

    def test_runs
      test_runs = self.class.client.test_runs(project: @project.id, test_cycle: @id) || []
      test_runs.map do |test_run|
        test_run.project = @project
        test_run.test_cycle = self
        test_run
      end
    end
  end
end

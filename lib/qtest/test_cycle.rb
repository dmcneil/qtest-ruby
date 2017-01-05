module QTest
  class TestCycle < QTest::Base
    attr_accessor :id, :project, :release

    def initialize(opts={})
      @id = opts[:id]
      @project = opts[:project]
      @release = opts[:release]
    end

    def test_suites
      test_suites = self.class.client.test_suites(project: @project.id,
                                                 test_cycle: @id) || []

      test_suites.map do |test_suite|
        test_suite.project = @project
        test_suite.test_cycle = self
        test_suite
      end
    end

    def create_test_suite(opts={})
      test_suite = self.class.client.create_test_suite(project: @project.id,
                                                       test_cycle: @id,
                                                       name: opts[:name])

      if test_suite
        test_suite.project = @project
        test_suite.test_cycle = self
      end

      test_suite
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

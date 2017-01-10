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
      test_runs = client.test_runs({
        project: @project.id,
        test_suite: @id
      })

      test_runs.map do |test_run|
        test_run[:project] = @project
        test_run[:test_suite] = self
        test_run[:release] = @release

        QTest::TestRun.new(test_run)
      end
    end

    def move(opts = {})
      client.move_test_suite({
        project: @project.id,
        test_suite: @id,
        release: opts[:release],
        test_cycle: opts[:test_cycle]
      })

      if opts[:release]
        release = client.release({
          project: @project.id,
          release: opts[:release]
        })

         @release = QTest::Release.new(release)
      elsif opts[:test_cycle]
        test_cycle = client.test_cycle({
          project: @project.id,
          test_cycle: opts[:test_cycle]
        })

        @test_cycle = QTest::TestCycle.new(test_cycle)
      end

      self
    end
  end
end

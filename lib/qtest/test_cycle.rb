module QTest
  class TestCycle < QTest::Base
    attr_accessor :id, :project, :release, :test_cycle

    def initialize(opts = {})
      @id = opts[:id]
      @project = opts[:project]
      @test_cycle = opts[:test_cycle]
      @release = opts[:release]
    end

    # Get all Test Cycles under the Test Cycle.
    #
    # @return [Array[QTest::TestCycle]]
    def test_cycles
      test_cycles = client.test_cycles(project: @project.id,
                                       test_cycle: @id)

      test_cycles.map do |test_cycle|
        test_cycle[:project] = @project
        test_cycle[:test_cycle] = self

        QTest::TestCycle.new(test_cycle)
      end
    end

    def create_test_cycle(opts = {})
      test_cycle = client.create_test_cycle({
        project: @project.id,
        test_cycle: @id,
        attributes: {
          name: opts[:name],
          description: opts[:description]
        }
      })
      test_cycle[:project] = @project
      test_cycle[:test_cycle] = self

      QTest::TestCycle.new(test_cycle)
    end

    # Get all Test Suites under the Test Cycle.
    #
    # @return [Array[QTest::TestSuite]]
    def test_suites
      test_suites = client.test_suites(project: @project.id,
                                       test_cycle: @id)

      test_suites.map do |test_suite|
        test_suite[:project] = @project
        test_suite[:test_cycle] = self

        QTest::TestSuite.new(test_suite)
      end
    end

    # Create a Test Suite under the Test Cycle.
    #
    # @return [QTest::TestSuite]
    def create_test_suite(opts = {})
      test_suite = client.create_test_suite({
        project: @project.id,
        test_cycle: @id,
        attributes: {
          name: opts[:name]
        }
      })
      test_suite[:project] = @project
      test_suite[:test_cycle] = self

      QTest::TestSuite.new(test_suite)
    end

    # Get all Test Runs under the Test Cycle.
    #
    # @return [Array[QTest::TestRun]]
    def test_runs
      test_runs = client.test_runs(project: @project.id,
                                   test_cycle: @id)
      test_runs.map do |test_run|
        test_run[:project] = @project
        test_run[:test_cycle] = self

        QTest::TestRun.new(test_run)
      end
    end
  end
end

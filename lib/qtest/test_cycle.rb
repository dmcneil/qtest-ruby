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
      all(QTest::TestCycle, project: @project.id, test_cycle: @id)
    end

    def create_test_cycle(opts = {})
      create(QTest::TestCycle,
             project: @project.id,
             test_cycle: @id,
             attributes: opts)
    end

    # Get all Test Suites under the Test Cycle.
    #
    # @return [Array[QTest::TestSuite]]
    def test_suites
      all(QTest::TestSuite, project: @project.id, test_cycle: @id)
    end

    # Create a Test Suite under the Test Cycle.
    #
    # @return [QTest::TestSuite]
    def create_test_suite(opts = {})
      create(QTest::TestSuite,
             project: @project.id,
             test_cycle: @id,
             attributes: opts)
    end

    # Get all Test Runs under the Test Cycle.
    #
    # @return [Array[QTest::TestRun]]
    def test_runs
      all(QTest::TestRun, project: @project.id, test_cycle: @id)
    end
  end
end

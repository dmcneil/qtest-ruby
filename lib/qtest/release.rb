module QTest
  class Release < QTest::Base
    attr_accessor :id, :project

    def initialize(opts = {})
      @id = opts[:id]
      @project = opts[:project]
    end

    # Get all Test Cycles under the Release.
    #
    # @return [Array[QTest::TestCycle]]
    def test_cycles
      all(QTest::TestCycle, project: @project.id, release: @id)
    end

    # Get all Test Suites under the Release.
    #
    # @return [Array[QTest::TestSuite]]
    def test_suites
      all(QTest::TestSuite, project: @project.id, release: @id)
    end

    # Create a Test Suite under the Release.
    #
    # @return [QTest::TestSuite]
    def create_test_suite(opts = {})
      create(QTest::TestSuite,
             project: @project.id,
             release: @id,
             attributes: opts)
    end

    # Create a Test Cycle under the Release.
    #
    # @return [QTest::TestCycle]
    def create_test_cycle(opts = {})
      create(QTest::TestCycle,
             project: @project.id,
             release: @id,
             attributes: opts)
    end
  end
end

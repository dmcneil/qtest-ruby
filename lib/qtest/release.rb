module QTest
  class Release < QTest::Base
    attr_accessor :id, :name, :order, :pid, :properties, :web_url, :project
    attr_reader :start_date, :end_date

    alias tag pid
    alias url web_url

    def initialize(opts = {})
      super

      @id = opts[:id]
      @project = opts[:project]
    end

    def start_date=(start_date)
      @start_date = Time.parse(start_date)
    end

    def end_date=(end_date)
      @end_date = Time.parse(end_date)
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

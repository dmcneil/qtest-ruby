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

    # Get all Test Cases under the Test Cycle.
    #
    # @return [Array[QTest::TestCase]]
    def test_cases
      all(QTest::TestCase, project: @project.id, test_run: @id)
    end
  end
end

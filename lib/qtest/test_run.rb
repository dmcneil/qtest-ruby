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
  end
end

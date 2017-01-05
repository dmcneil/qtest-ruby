module QTest
  class TestRun < QTest::Base
    attr_accessor :id, :release, :test_cycle, :project

    def initialize(opts={})
      @id = opts[:id]
      @release = opts[:release]
      @test_cycle = opts[:test_cycle]
      @project = opts[:project]
    end
  end
end

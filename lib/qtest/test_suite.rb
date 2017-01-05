module QTest
  class TestSuite
    attr_accessor :id, :project, :test_cycle, :release

    def initialize(opts={})
      @id = opts[:id]
      @project = opts[:project]
      @test_cycle = opts[:test_cycle]
      @release = opts[:release]
    end
  end
end

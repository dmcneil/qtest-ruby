module QTest
  class TestStep
    attr_accessor :id, :test_case, :project

    def initialize(opts = {})
      @id = opts[:id]
      @test_case = opts[:test_case]
      @project = opts[:project]
    end
  end
end

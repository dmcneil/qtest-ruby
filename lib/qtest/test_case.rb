module QTest
  class TestCase < QTest::Base
    attr_accessor :id, :project, :module, :test_run

    def initialize(opts = {})
      @id = opts[:id]
      @project = opts[:project]
      @module = opts[:module]
      @test_run = opts[:test_run]
    end

    def step(opts = {})
      unique(QTest::TestStep,
             project: @project.id,
             test_case: @id,
             id: opts[:id])
    end

    def steps
      all(QTest::TestStep, project: @project.id, test_case: @id)
    end
  end
end

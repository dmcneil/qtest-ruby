module QTest
  class TestCase < QTest::Base
    attr_accessor :id, :project, :test_cycle, :release, :test_suite,
                  :test_run

    def initialize(opts = {})
      @id = opts[:id]
      @project = opts[:project]
      @test_cycle = opts[:test_cycle]
      @release = opts[:release]
      @test_suite = opts[:test_suite]
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

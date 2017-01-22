module QTest
  class TestCase < QTest::Base
    attr_accessor :id, :name, :tag, :project, :module, :test_run

    def initialize(opts = {})
      @id = opts[:id]
      @name = opts[:name]
      @tag = opts[:tag] || opts[:pid]

      @project = opts[:project]
      @module = opts[:module]
      @test_run = opts[:test_run]
    end

    # Get a specific Test Step under the Test Case.
    #
    # @param opts [Hash]
    # @option id [Integer] id of the Test Step
    # @return [QTest::TestStep]
    def step(opts = {})
      unique(QTest::TestStep,
             project: @project.id,
             test_case: @id,
             id: opts[:id])
    end

    # Get all Test Steps under the Test Case.
    #
    # @return [Array[QTest::TestStep]]
    def steps
      all(QTest::TestStep, project: @project.id, test_case: @id)
    end
  end
end

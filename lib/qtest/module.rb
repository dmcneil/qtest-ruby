module QTest
  class Module < QTest::Base
    attr_accessor :id, :project, :module

    def initialize(opts = {})
      @id = opts[:id]
      @project = opts[:project]
      @module = opts[:module]
    end

    # Get a specific child Module under the Module.
    #
    # @param opts [Hash]
    # @option id [Integer] id of the child Module
    # @return [QTest::Module]
    def child_module(opts = {})
      unique(QTest::Module,
             project: @project.id,
             module: @id,
             id: opts[:id])
    end

    # Get all child Modules under the Module.
    #
    # @param opts [Hash]
    # @option search [String] keyword to search for in a Module name
    # @return [Array[QTest::Module]]
    def child_modules(opts = {})
      all(QTest::Module,
          project: @project.id,
          module: @id,
          search: opts[:search])
    end

    # Get all Test Cases under the Module.
    #
    # @return [Array[QTest::TestCase]]
    def test_cases
      all(QTest::TestCase,
          project: @project.id,
          module: @id)
    end
  end
end

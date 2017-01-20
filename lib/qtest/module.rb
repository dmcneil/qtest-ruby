module QTest
  class Module < QTest::Base
    attr_accessor :id, :project, :module

    def initialize(opts = {})
      @id = opts[:id]
      @project = opts[:project]
      @module = opts[:module]
    end

    def child_module(opts = {})
      unique(QTest::Module,
             project: @project.id,
             module: @id,
             id: opts[:id])
    end

    def child_modules(opts = {})
      all(QTest::Module,
          project: @project.id,
          module: @id,
          search: opts[:search])
    end

    def test_cases(opts = {})
      all(QTest::TestCase,
          project: @project.id,
          module: @id)
    end
  end
end

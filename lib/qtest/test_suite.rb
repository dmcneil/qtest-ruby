module QTest
  class TestSuite < QTest::Base
    attr_accessor :id, :project, :test_cycle, :release

    def initialize(opts = {})
      @id = opts[:id]
      @project = opts[:project]
      @test_cycle = opts[:test_cycle]
      @release = opts[:release]
    end

    # Get all Test Runs for the Test Suite.
    #
    # @return [Array[QTest::TestRun]]
    def test_runs
      all(QTest::TestRun, project: @project.id, test_suite: @id)
    end

    # Create a Test Run under the Test Suite.
    #
    # @return [QTest::TestRun]
    def create_test_run(opts = {})
      create(QTest::TestRun,
             project: @project.id,
             test_suite: @id,
             attributes: opts)
    end

    # Move the Test Suite under a different parent.
    #
    # @return [QTest::TestSuite]
    def move_to(opts = {})
      move(project: @project.id,
           test_suite: @id,
           release: opts[:release],
           test_cycle: opts[:test_cycle])

      if opts[:release]
        @release = unique(QTest::Release,
                          project: @project.id,
                          release: opts[:release])
      elsif opts[:test_cycle]
        @test_cycle = unique(QTest::TestCycle,
                             project: @project.id,
                             test_cycle: opts[:test_cycle])
      end

      self
    end
    alias move_under move_to
  end
end

module QTest
  class Release < QTest::Base
    attr_accessor :id, :project

    def initialize(opts={})
      @id = opts[:id]
      @project = opts[:project]
    end

    # Get a specific Test Cycle under the Release.
    #
    # ## Options
    #
    #     * :id - the Test Cycle ID
    #
    # @return [QTest::TestCycle]
    def test_cycle(opts={})
      test_cycle = self
                   .class
                   .client
                   .test_cycle(project: @project.id, release: @id, id: opts[:id])

      if test_cycle
        test_cycle.release = self
        test_cycle.project = @project
      end

      test_cycle
    end

    # Get all Test Cycles under the Release.
    #
    # @return [Array[QTest::TestCycle]]
    def test_cycles
      test_cycles = self
                    .class
                    .client
                    .test_cycles(project: @project.id, release: @id)

      test_cycles.map do |test_cycle|
        test_cycle.release = self
        test_cycle.project = @project
        test_cycle
      end
    end
  end
end

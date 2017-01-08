module QTest
  class Release < QTest::Base
    attr_accessor :id, :project

    def initialize(opts = {})
      @id = opts[:id]
      @project = opts[:project]
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

    # Get all Test Suites under the Release.
    #
    # @return [Array[QTest::TestSuite]]
    def test_suites
      test_suites = self
                    .class
                    .client
                    .test_suites(project: @project.id, release: @id)

      test_suites.map do |test_suite|
        test_suite.release = self
        test_suite.project = @project
        test_suite
      end
    end

    def create_test_suite(opts = {})
      test_suite = self.class.client.create_test_suite({
        project: @project.id,
        release: @id,
        name: opts[:name],
        properties: opts[:properties]
      })

      test_suite.project = @project
      test_suite.release = self
      test_suite
    end
  end
end

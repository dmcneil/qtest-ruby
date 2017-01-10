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
      test_cycles = client.test_cycles(project: @project.id, release: @id)

      test_cycles.map do |test_cycle|
        test_cycle[:release] = self
        test_cycle[:project] = @project

        QTest::TestCycle.new(test_cycle)
      end
    end

    # Get all Test Suites under the Release.
    #
    # @return [Array[QTest::TestSuite]]
    def test_suites
      test_suites = client.test_suites(project: @project.id, release: @id)

      test_suites.map do |test_suite|
        test_suite[:release] = self
        test_suite[:project] = @project

        QTest::TestSuite.new(test_suite)
      end
    end

    # Create a Test Suite under the Release.
    #
    # @return [QTest::TestSuite]
    def create_test_suite(opts = {})
      test_suite = client.create_test_suite({
        project: @project.id,
        release: @id,
        attributes: {
          name: opts[:name],
          properties: opts[:properties],
          target_build_id: opts[:target_build]
        }
      })
      test_suite[:project] = @project
      test_suite[:release] = self


      QTest::TestSuite.new(test_suite)
    end

    # Create a Test Cycle under the Release.
    #
    # @return [QTest::TestCycle]
    def create_test_cycle(opts = {})
      test_cycle = client.create_test_cycle({
        project: @project.id,
        release: @id,
        attributes: {
          name: opts[:name],
          description: opts[:description]
        }
      })
      test_cycle[:project] = @project
      test_cycle[:release] = self

      QTest::TestCycle.new(test_cycle)
    end
  end
end

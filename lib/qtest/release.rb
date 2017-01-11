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
      all(QTest::TestCycle, project: @project.id, release: @id)
    end

    # Get all Test Suites under the Release.
    #
    # @return [Array[QTest::TestSuite]]
    def test_suites
      all(QTest::TestSuite, project: @project.id, release: @id)
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

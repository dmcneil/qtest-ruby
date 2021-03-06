module QTest
  class TestCase < QTest::Base
    class << self
      def find_by(opts = {})
        opts[:page] ||= 1
        super
      end
    end

    attr_accessor :id, :name, :pid, :order, :web_url, :test_case_version_id,
                  :precondition, :description, :project, :module, :test_run

    alias tag pid
    alias url web_url
    alias version test_case_version_id

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

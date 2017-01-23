module QTest
  class Project < QTest::Base
    attr_accessor :id

    # Get a specific Release under the Project.
    #
    # @param opts [Hash]
    # @option id [Integer] id of the Release
    # @return [QTest::Release]
    def release(opts = {})
      unique(QTest::Release, project: @id, id: opts[:id])
    end

    # Get all Releases under the Project.
    #
    # @return [Array[QTest::Release]]
    def releases
      all(QTest::Release, project: @id)
    end

    # Get a specific Module under the Project.
    #
    # @param opts [Hash]
    # @option id [Integer] id of the Module
    # @return [QTest::Module]
    def module(opts = {})
      unique(QTest::Module, project: @id, id: opts[:id])
    end

    # Get all Releases under the Project.
    #
    # @return [Array[QTest::Module]]
    def modules
      all(QTest::Module, project: @id)
    end
  end
end

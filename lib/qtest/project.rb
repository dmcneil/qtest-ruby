module QTest
  class Project < Base
    class << self
      def find_by(opts = {})
        project = client.project(opts[:id]) if opts[:id]

        self.new(project)
      end
    end

    attr_accessor :id

    def initialize(opts = {})
      @id = opts[:id]
    end

    # Get a specific Release under the Project.
    #
    # ## Options
    #
    #     * :id - the Release ID
    #
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
  end
end

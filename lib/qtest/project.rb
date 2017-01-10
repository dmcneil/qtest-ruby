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
      release = client.release(project: @id, id: opts[:id])
      release[:project] = self

      QTest::Release.new(release)
    end

    # Get all Releases under the Project.
    #
    # @return [Array[QTest::Release]]
    def releases
      releases = client.releases(project: @id)
      releases.map do |release|
        release[:project] = self

        QTest::Release.new(release)
      end
    end
  end
end

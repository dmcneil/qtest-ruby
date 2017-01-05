module QTest
  class Project < Base
    class << self
      def find_by(opts={})
        client.project(opts[:id]) if opts[:id]
      end
    end

    attr_accessor :id

    def initialize(opts={})
      @id = opts[:id]
    end

    # Get a specific Release under the Project.
    #
    # ## Options
    #
    #     * :id - the Release ID
    #
    # @return [QTest::Release]
    def release(opts={})
      self.class.client.release(project: @id, id: opts[:id])
    end

    # Get all Releases under the Project.
    #
    # @return [Array[QTest::Release]]
    def releases
      self.class.client.releases(project: @id)
    end
  end
end

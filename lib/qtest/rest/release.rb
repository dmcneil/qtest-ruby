module QTest
  module REST
    module Release
      include QTest::REST::Utils

      # GET '/projects/:project/releases/:id'
      def release(opts = {})
        query = QueryBuilder.new
                .project(opts[:project])
                .release(opts[:id])
                .build
        get(query)
      end

      # GET '/projects/:project/releases'
      def releases(opts = {})
        query = QueryBuilder.new
                .project(opts[:project])
                .releases
                .build
        get(query)
      end
    end
  end
end

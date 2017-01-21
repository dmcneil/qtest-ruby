module QTest
  module REST
    module TestCycle
      include QTest::REST::Utils

      # GET '/projects/:project/test-cycles/:id'
      def test_cycle(opts = {})
        query = QueryBuilder.new
                            .project(opts[:project])
                            .test_cycle(opts[:id])
                            .build

        get(query)
      end

      # GET '/projects/:project/test-cycles'
      def test_cycles(opts = {})
        query = QueryBuilder.new
                            .project(opts[:project])
                            .test_cycles
                            .determine_parent!(opts)
                            .build

        get(query)
      end

      # POST '/projects/:project/test-cycles'
      def create_test_cycle(opts = {})
        query = QueryBuilder.new
                            .options(:json)
                            .project(opts[:project])
                            .test_cycles
                            .data(opts[:attributes])
                            .determine_parent!(opts)
                            .build

        post(query)
      end

      # PUT '/projects/:project/test-cycles/:id?parentType=?@parentId=?'
      def move_test_cycle(opts = {})
        query = QueryBuilder.new
                            .project(opts[:project])
                            .test_cycle(opts[:id])
                            .determine_parent!(opts)
                            .build

        put(query)
      end

      # PUT '/projects/:project/test-cycles/:id'
      def update_test_cycle(opts = {})
        query = QueryBuilder.new
                            .options(:json)
                            .project(opts[:project])
                            .test_cycle(opts[:id])
                            .data(opts[:attributes])
                            .build

        put(query)
      end

      # DELETE '/projects/:project/test-cycles/:id?force=?'
      def delete_test_cycle(opts = {})
        query = QueryBuilder.new
                            .project(opts[:project])
                            .test_cycle(opts[:id])

        query.param(:force, opts[:force] || false) if opts[:force]
        query = query.build

        delete(query)
      end
    end
  end
end

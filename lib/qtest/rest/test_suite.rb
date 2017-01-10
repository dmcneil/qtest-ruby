module QTest
  module REST
    module TestSuite
      include QTest::REST::Utils

      # GET '/projects/:project/test-suites/:id'
      def test_suite(opts = {})
        query = QueryBuilder.new
                .project(opts[:project])
                .test_suite(opts[:id])

        determine_parent!(opts)
        query.under(opts[:parent][:type], opts[:parent][:id]) if opts[:parent]
        query = query.build

        get(query)
      end

      def test_suites(opts = {})
        query = QueryBuilder.new
                .project(opts[:project])
                .test_suites

        determine_parent!(opts)
        query.under(opts[:parent][:type], opts[:parent][:id]) if opts[:parent]
        query = query.build

        get(query)
      end

      def create_test_suite(opts = {})
        query = QueryBuilder.new
                .project(opts[:project])
                .test_suites
                .data(opts[:attributes])

        determine_parent!(opts)
        query.under(opts[:parent][:type], opts[:parent][:id]) if opts[:parent]
        query = query.build(:json)

        post(query)
      end

      def move_test_suite(opts = {})
        query = QueryBuilder.new
                .project(opts[:project])
                .test_suite(opts[:id])

        determine_parent!(opts)
        query.under(opts[:parent][:type], opts[:parent][:id]) if opts[:parent]
        query = query.build

        put(query)
      end

      def update_test_suite(opts = {})
        query = QueryBuilder.new
                .project(opts[:project])
                .test_suite(opts[:id])
                .data(opts[:attributes])
                .build(:json)

        put(query)
      end
    end
  end
end

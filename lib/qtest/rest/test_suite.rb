module QTest
  module REST
    module TestSuite
      include QTest::REST::CRUD
      include QTest::REST::Utils

      def test_suite(args={})
        path = build_path('/api/v3/projects',
                          args[:project],
                          'test-suites',
                          args[:id])

        get(QTest::TestSuite, path)
      end

      def test_suites(args={})
        options = {}
        if args[:release]
          options[:query] = release_parent_query_param(args[:release])
        elsif args[:test_cycle]
          options[:query] = test_cycle_parent_query_param(args[:test_cycle])
        elsif args[:test_suite]
          options[:query] = test_suite_parent_query_param(args[:test_suite])
        end

        path = build_path('/api/v3/projects', args[:project], 'test-suites')
        get(QTest::TestSuite, path, options)
      end

      def create_test_suite(args={})
        options = {
          body: {
            name: args[:name]
          }
        }

        if args[:test_cycle]
          options[:query] = test_cycle_parent_query_param(args[:test_cycle])
        elsif args[:release]
          options[:query] = release_parent_query_param(args[:release])
          options[:body][:target_build_id] = args[:target_build]
        end

        path = build_path('/api/v3/projects', args[:project], 'test-suites')
        post(QTest::TestSuite, path, options)
      end
    end
  end
end

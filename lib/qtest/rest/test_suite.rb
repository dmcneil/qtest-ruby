module QTest
  module REST
    module TestSuite
      include QTest::REST::CRUD
      include QTest::REST::Utils

      def test_suite(opts={})
        path = build_path('/api/v3',
                          :projects,
                          opts[:project],
                          'test-suites',
                          opts[:id])
        response = handle_response(self.class.get(path))
        deserialize_response(response, QTest::TestSuite)
      end

      def test_suites(opts={})
        options = {}
        if opts[:release]
          options[:query] = release_parent_query_param(opts[:release])
        elsif opts[:test_cycle]
          options[:query] = test_cycle_parent_query_param(opts[:test_cycle])
        elsif opts[:test_suite]
          options[:query] = test_suite_parent_query_param(opts[:test_suite])
        end

        options[:path] = build_path('/api/v3',
                                    :projects,
                                    opts[:project],
                                    'test-suites')
        read(QTest::TestSuite, options)
      end

      def create_test_suite(args={})
        options = {
          path: build_path('/api/v3/projects', args[:project], 'test-suites'),
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

        create(QTest::TestSuite, options)
      end
    end
  end
end

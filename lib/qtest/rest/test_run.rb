module QTest
  module REST
    module TestRun
      include QTest::REST::Utils
      include QTest::REST::CRUD

      def test_run(args={})
        path = build_path('/api/v3/projects', args[:project], 'test-runs', args[:id])
        response = handle_response(self.class.get(path))
        deserialize_response(response, QTest::TestRun)
      end

      def test_runs(args={})
        options = {}
        if args[:release]
          options[:query] = build_parent_query_param(args[:release], :release)
        elsif args[:test_cycle]
          options[:query] = build_parent_query_param(args[:test_cycle], :test_cycle)
        elsif args[:test_suite]
          options[:query] = build_parent_query_param(args[:test_suite], :test_suite)
        end

        path = build_path('/api/v3/projects', args[:project], 'test-runs')
        response = handle_response(self.class.get(path, options))
        deserialize_response(response, QTest::TestRun)
      end

      def create_test_run(args={})
        options = {
          path: build_path('/api/v3/projects', args[:project], 'test-runs'),
          body: {
            name: args[:name],
            description: args[:description]
          }
        }
        options[:body][:test_case_version_id] = args[:test_case] if args[:test_case]
        options[:query] = release_parent_query_param(args[:release]) if args[:release]
        options[:query] = release_parent_query_param(args[:test_cycle]) if args[:test_cycle]
        options[:query] = release_parent_query_param(args[:test_suite]) if args[:test_suite]

        create(QTest::TestRun, options)
      end

      def execution_statuses(args={})
        path = build_path('/api/v3/projects', args[:project], 'test-runs/execution-statuses')
        handle_response(self.class.get(path))
      end

      def test_run_fields(args={})
        path = build_path('/api/v3/projects', args[:project], 'test-runs/fields')
        handle_response(self.class.get(path))
      end
    end
  end
end

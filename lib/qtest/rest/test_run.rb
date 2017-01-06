module QTest
  module REST
    module TestRun
      include QTest::REST::Utils
      include QTest::REST::CRUD

      # Get a Test Run by its ID.
      #
      # ## Options
      #
      #     * :id - The Test Run ID
      #     * :project - The parent Project ID
      #
      # @return [QTest::TestRun]
      def test_run(args={})
        path = build_path('/api/v3/projects', args[:project], 'test-runs', args[:id])
        get(QTest::TestRun, path)
      end

      # Get a collection of Test Runs.
      #
      # ## Options
      #
      #     * :project - The parent Project ID
      #
      #     * :test_cycle - The parent Test Cycle ID
      #     # OR
      #     * :release - The parent Release ID
      #     # OR
      #     * :test_suite - The parent Test Suite ID
      #
      # @return [Array[QTest::TestRun]
      def test_runs(args={})
        options = {}
        if args[:release]
          options[:query] = release_parent_query_param(args[:release])
        elsif args[:test_cycle]
          options[:query] = test_cycle_parent_query_param(args[:test_cycle])
        elsif args[:test_suite]
          options[:query] = test_suite_parent_query_param(args[:test_suite])
        end

        path = build_path('/api/v3/projects', args[:project], 'test-runs')
        get(QTest::TestRun, path, options)
      end

      # Create a new Test Run.
      #
      # ## Options
      #
      #     * :id - The Test Run ID
      #     * :project - The parent Project ID
      #     * :name - The name of the Test Run
      #
      #     * :test_cycle - The parent Test Cycle ID
      #     # OR
      #     * :release - The parent Release ID
      #     # OR
      #     * :test_suite - The parent Test Suite ID
      #
      # Only the `:test_cycle` or `:release` option need be passed. If for
      # whatever reason both are supplied, the `:test_cycle` takes precedence.
      #
      # @return [QTest::TestRun]
      def create_test_run(args={})
        options = {
          body: {
            name: args[:name],
            test_case: {}
          }
        }

        if args[:test_case]
          options[:body][:test_case] = args[:test_case]
        end

        if args[:release]
          options[:query] = release_parent_query_param(args[:release])
        elsif args[:test_cycle]
          options[:query] = test_cycle_parent_query_param(args[:test_cycle])
        elsif args[:test_suite]
          options[:query] = test_suite_parent_query_param(args[:test_suite])
        end

        path = build_path('/api/v3/projects', args[:project], 'test-runs')
        post(QTest::TestRun, path, options)
      end

      # Move a Test Run to another container.
      #
      # ## Options
      #
      #     * :id - The Test Run ID
      #     * :project - The parent Project ID
      #     * :name - The name of the Test Run
      #     * :description - A description for the Test Run
      #
      #     * :test_cycle - The parent Test Cycle ID
      #     # OR
      #     * :release - The parent Release ID
      #     # OR
      #     * :test_suite - The parent Test Suite ID
      #
      # @return [QTest::TestRun]
      def move_test_run(args={})
        options = {}

        if args[:test_cycle]
          options[:query] = test_cycle_parent_query_param(args[:test_cycle])
        elsif args[:release]
          options[:query] = release_parent_query_param(args[:release])
        elsif args[:test_suite]
          options[:query] = test_suite_parent_query_param(args[:test_suite])
        end

        path = build_path('/api/v3/projects',
                          args[:project],
                          'test-runs',
                          args[:id])
        put(QTest::TestRun, path, options)
      end

      # Update a Test Run.
      #
      # ## Options
      #
      #     * :id - The Test Run ID
      #     * :project - The parent Project ID
      #     * :name - The new name of the Test Run
      #     * :description - A new description for the Test Run
      #
      # @return [QTest::TestRun]
      def update_test_run(args={})
        options = {
          body: {}
        }

        options[:body][:name] = args[:name] if args[:name]
        options[:body][:description] = args[:name] if args[:description]

        path = build_path('/api/v3/projects',
                          args[:project],
                          'test-runs',
                          args[:id])
        put(QTest::TestRun, path, options)
      end

      # Delete a Test Run.
      #
      # ## Options
      #
      #     * :id - The Test Run ID
      #     * :project - The parent Project ID
      #
      def delete_test_run(args={})
        path = build_path('/api/v3/projects', args[:project], 'test-runs', args[:id])
        delete(path)
      end

      def execution_statuses(args={})
        path = build_path('/api/v3/projects', args[:project], 'test-runs/execution-statuses')
        get(Hash, path)
      end

      def test_run_fields(args={})
        path = build_path('/api/v3/projects', args[:project], 'test-runs/fields')
        get(Hash, path)
      end
    end
  end
end

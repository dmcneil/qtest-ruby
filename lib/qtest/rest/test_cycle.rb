module QTest
  module REST
    module TestCycle
      include QTest::REST::Utils
      include QTest::REST::CRUD

      # Get a Test Cycle by its ID.
      #
      # ## Options
      #
      #     * :id - The Test Cycle ID
      #     * :project - The parent Project ID
      #
      # @return [QTest::TestCycle]
      def test_cycle(args={})
        path = build_path('/api/v3/projects', args[:project], 'test-cycles', args[:id])
        get(QTest::TestCycle, path)
      end

      # Get a collection of Test Cycles.
      #
      # ## Options
      #
      #     * :project - The parent Project ID
      #
      #     * :test_cycle - The parent Test Cycle ID
      #     # OR
      #     * :release - The parent Release ID
      #
      # Only the `:test_cycle` or `:release` option need be passed. If for
      # whatever reason both are supplied, the `:test_cycle` takes precedence.
      #
      # @return [Array[QTest::TestCycle]]
      def test_cycles(args={})
        options = {}
        if args[:test_cycle]
          options[:query] = test_cycle_parent_query_param(args[:test_cycle])
        elsif args[:release]
          options[:query] = release_parent_query_param(args[:release])
        end

        path = build_path('/api/v3/projects', args[:project], 'test-cycles')
        get(QTest::TestCycle, path, options)
      end

      # Create a new Test Cycle.
      #
      # ## Options
      #
      #     * :id - The Test Cycle ID
      #     * :project - The parent Project ID
      #     * :name - The name of the Test Cycle
      #     * :description - A description for the Test Cycle
      #
      #     * :test_cycle - The parent Test Cycle ID
      #     # OR
      #     * :release - The parent Release ID
      #     * :target_build - The target build ID
      #
      # Only the `:test_cycle` or `:release` option need be passed. If for
      # whatever reason both are supplied, the `:test_cycle` takes precedence.
      #
      # If the `:release` key is passed in, you **must** supply the additional
      # `:target_build` key.
      #
      # @return [QTest::TestCycle]
      def create_test_cycle(args={})
        options = {
          body: {
            name: args[:name],
            description: args[:description]
          }
        }

        if args[:test_cycle]
          options[:query] = test_cycle_parent_query_param(args[:test_cycle])
        elsif args[:release]
          options[:query] = release_parent_query_param(args[:release])
          options[:body][:target_build_id] = args[:target_build]
        end

        path = build_path('/api/v3/projects', args[:project], 'test-cycles')
        post(QTest::TestCycle, path, options)
      end

      # Move a Test Cycle to another container.
      #
      # ## Options
      #
      #     * :id - The Test Cycle ID
      #     * :project - The parent Project ID
      #     * :name - The name of the Test Cycle
      #     * :description - A description for the Test Cycle
      #
      #     * :test_cycle - The parent Test Cycle ID
      #     # OR
      #     * :release - The parent Release ID
      #
      # Only the `:test_cycle` or `:release` option need be passed. If for
      # whatever reason both are supplied, the `:test_cycle` takes precedence.
      #
      # @return [QTest::TestCycle]
      def move_test_cycle(args={})
        options = {}

        if args[:test_cycle]
          options[:query] = test_cycle_parent_query_param(args[:test_cycle])
        elsif args[:release]
          options[:query] = release_parent_query_param(args[:release])
        end

        path = build_path('/api/v3/projects',
                          args[:project],
                          'test-cycles',
                          args[:id])
        put(QTest::TestCycle, path, options)
      end

      # Update a Test Cycle.
      #
      # ## Options
      #
      #     * :id - The Test Cycle ID
      #     * :project - The parent Project ID
      #     * :name - The new name of the Test Cycle
      #     * :description - A new description for the Test Cycle
      #
      # @return [QTest::TestCycle]
      def update_test_cycle(args={})
        options = {
          body: {}
        }

        options[:body][:name] = args[:name] if args[:name]
        options[:body][:description] = args[:description] if args[:description]

        path = build_path('/api/v3/projects',
                          args[:project],
                          'test-cycles',
                          args[:id])
        put(QTest::TestCycle, path, options)
      end

      # Delete a Test Cycle.
      #
      # ## Options
      #
      #     * :id - The Test Cycle ID
      #     * :project - The parent Project ID
      #     * :force - If true, delete all children of the Test Cycle
      #
      def delete_test_cycle(args={})
        options = {
          query: {
            force: args[:force] || false
          }
        }

        path = build_path('/api/v3/projects',
                          args[:project],
                          'test-cycles',
                          args[:id])
        delete(path, options)
      end
    end
  end
end

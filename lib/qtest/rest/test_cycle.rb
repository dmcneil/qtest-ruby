module QTest
  module REST
    module TestCycle
      include QTest::REST::Utils

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
        response = handle_response(self.class.get(path))
        deserialize_response(response, QTest::TestCycle)
      end

      # Get a collection of Test Cycles.
      #
      # ## Options
      #
      #     * :id - The Test Cycle ID
      #     * :project - The parent Project ID
      #
      #     * :test_cycle - The parent Test Cycle
      #     # OR
      #     * :release - The parent Release
      #
      # Only the `:test_cycle` or `:release` option need be passed. If for
      # whatever reason both are supplied, the `:test_cycle` takes precedence.
      #
      # @return [Array[QTest::TestCycle]]
      def test_cycles(args={})
        options = {}
        if args[:test_cycle]
          options[:query] = {
            'parentId' => args[:test_cycle],
            'parentType' => 'test-cycle'
          }
        elsif args[:release]
          options[:query] = {
            'parentId' => args[:release],
            'parentType' => 'release'
          }
        end

        path = build_path('/api/v3/projects', args[:project], 'test-cycles')
        response = handle_response(self.class.get(path, options))
        deserialize_response(response, QTest::TestCycle)
      end

      # Create a new Test Cycle.
      #
      # ## Options
      #
      #     * :id - The Test Cycle ID
      #     * :project - The parent Project ID
      #     * :name - The name of the Test Cycle
      #     * :description - A description for the Test Cycle
      #     * :test_cycle - The parent Test Cycle ID
      #
      #     * :target_build - The target build ID
      #     # OR
      #     * :release - The parent Release ID
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
          headers: {'Content-Type' => 'application/json'},
          body: {
            name: args[:name],
            description: args[:description]
          }
        }

        if args[:test_cycle]
          options[:query] = {
            'parentId' => args[:test_cycle],
            'parentType' => 'test-cycle'
          }
        elsif args[:release]
          options[:query] = {
            'parentId' => args[:release],
            'parentType' => 'release'
          }
          options[:body][:target_build_id] = args[:target_build]
        end

        path = build_path('/api/v3/projects', args[:project], 'test-cycles')
        response = handle_response(self.class.post(path, options))
        deserialize_response(response, QTest::TestCycle)
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
        options = {
          headers: {'Content-Type' => 'application/json'},
          body: {
            name: args[:name],
            description: args[:description]
          }
        }

        if args[:test_cycle]
          options[:query] = {
            'parentId' => args[:test_cycle],
            'parentType' => 'test-cycle'
          }
        elsif args[:release]
          options[:query] = {
            'parentId' => args[:release],
            'parentType' => 'release'
          }
        end

        path = build_path('/api/v3/projects', args[:project], 'test-cycles', args[:id])
        response = handle_response(self.class.put(path, options))
        deserialize_response(response, QTest::TestCycle)
      end

      # Delete a Test Cycle.
      #
      # ## Options
      #
      #     * :id - The Test Cycle ID
      #     * :project - The parent Project ID
      #
      def delete_test_cycle(args={})
        options = {
          query: {
            force: args[:force] || false
          }
        }

        path = build_path('/api/v3/projects', args[:project], 'test-cycles', args[:id])
        handle_response(self.class.delete(path, options), raw: true)
      end
    end
  end
end

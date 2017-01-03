module QTest
  module REST
    module TestCycle
      include QTest::REST::Utils

      def test_cycle(args={})
        path = build_path("/api/v3/projects", args[:project], "test-cycles", args[:id])
        response = handle_response(self.class.get(path))
        deserialize_response(response, QTest::TestCycle)
      end

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

        path = build_path("/api/v3/projects", args[:project], "test-cycles")
        response = handle_response(self.class.get(path, options))
        deserialize_response(response, QTest::TestCycle)
      end

      def create_test_cycle(args={})
        options = {
          headers: {'Content-Type' => 'application/json'},
          body: {
            name: args[:name],
            description: args[:description]
          }
        }

        if args[:release]
          options[:query] = {
            'parentId' => args[:release],
            'parentType' => 'release'
          }
          options[:body][:target_build_id] = args[:target_build_id]
        elsif args[:test_cycle]
          options[:query] = {
            'parentId' => args[:test_cycle],
            'parentType' => 'test-cycle'
          }
        end

        path = build_path("/api/v3/projects", args[:project], "test-cycles")
        response = handle_response(self.class.post(path, options))
        deserialize_response(response, QTest::TestCycle)
      end
    end
  end
end

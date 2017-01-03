module QTest
  module REST
    module TestRun
      include QTest::REST::Utils

      def test_run(args={})
        path = build_path("/api/v3/projects", args[:project], "test-runs", args[:id])
        response = handle_response(self.class.get(path))
        deserialize_response(response, QTest::TestRun)
      end

      def test_runs(args={})
        options = {}
        if args[:release]
          options[:query] = {
            'parentId' => args[:release],
            'parentType' => 'release'
          }
        elsif args[:test_cycle]
          options[:query] = {
            'parentId' => args[:test_cycle],
            'parentType' => 'test-cycle'
          }
        elsif args[:test_suite]
          options[:query] = {
            'parentId' => args[:test_suite],
            'parentType' => 'test-suite'
          }
        end

        path = build_path("/api/v3/projects", args[:project], "test-runs")
        response = handle_response(self.class.get(path, options))
        deserialize_response(response, QTest::TestRun)
      end

      def execution_statuses(args={})
        path = build_path("/api/v3/projects", args[:project], "test-runs/execution-statuses")
        response = handle_response(self.class.get(path))

      end
    end
  end
end

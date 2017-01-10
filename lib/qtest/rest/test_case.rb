module QTest
  module REST
    module TestCase
      include QTest::REST::Utils

      def test_case(opts = {})
        path = build_path('/api/v3/projects',
                          opts[:project],
                          'test-cases',
                          opts[:id])

        get(Hash, path)
      end

      def test_cases(opts = {})
        options = {}
        if opts[:release]
          options[:query] = release_parent_query_param(opts[:release])
        elsif opts[:test_cycle]
          options[:query] = test_cycle_parent_query_param(opts[:test_cycle])
        elsif opts[:test_suite]
          options[:query] = test_suite_parent_query_param(opts[:test_suite])
        end

        options[:query][:page] = opts[:page] || 1

        path = build_path('/api/v3/projects', opts[:project], 'test-cases')
        get(Hash, path, options)
      end

      def create_test_case(opts = {})
        options = {
          body: {
            name: opts[:name],
            description: opts[:description],
            properties: opts[:properties] || [],
            test_steps: opts[:steps] || []
          }
        }

        if opts[:test_cycle]
          options[:body][:parent_id] = opts[:test_cycle]
        elsif opts[:release]
          options[:body][:parent_id] = opts[:release]
        end

        path = build_path('/api/v3/projects', opts[:project], 'test-cases')
        post(Hash, path, options)
      end

      def update_test_case(opts = {})
        options = {
          body: {
            name: opts[:name],
            properties: opts[:properties]
          }
        }

        path = build_path('/api/v3/projects',
                          opts[:project],
                          'test-cases',
                          opts[:test_case])
        put(Hash, path, options)
      end
    end
  end
end

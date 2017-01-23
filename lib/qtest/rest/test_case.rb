module QTest
  module REST
    module TestCase
      include QTest::REST::Utils

      def test_case(opts = {})
        query = QueryBuilder.new
                            .project(opts[:project])
                            .test_case(opts[:id])
                            .build

        get(query)
      end

      def test_cases(opts = {})
        query = QueryBuilder.new
                            .project(opts[:project])
                            .test_cases
                            .param('parentId', opts[:module])
                            .param('page', opts[:page])
                            .param('expandProps', opts[:expand_properties])
                            .param('expandSteps', opts[:expand_steps])
                            .build

        get(query)
      end

      def create_test_case(opts = {})
        if opts[:attributes]
          opts[:attributes].merge!(parent_id: opts[:module])
        end

        query = QueryBuilder.new
                            .options(:json)
                            .project(opts[:project])
                            .test_cases
                            .data(opts[:attributes])
                            .build

        post(query)
      end

      def test_case_version(opts = {})
        query = QueryBuilder.new
                            .project(opts[:project])
                            .test_case(opts[:test_case])
                            .with(:versions, opts[:version])
                            .build

        get(query)
      end

      def test_case_versions(opts = {})
        query = QueryBuilder.new
                            .project(opts[:project])
                            .test_case(opts[:test_case])
                            .with(:versions)
                            .build

        get(query)
      end

      def test_step(opts = {})
        query = QueryBuilder.new
                            .project(opts[:project])
                            .test_case(opts[:test_case])
                            .with(:test_steps, opts[:id])
                            .build

        get(query)
      end
    end
  end
end

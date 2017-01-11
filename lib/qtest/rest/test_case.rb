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
                .determine_parent!(opts)
                .param(:page, opts[:page])
                .param('expandProps', opts[:expand_properties])
                .param('expandSteps', opts[:expand_steps])
                .build

        get(query)
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

      def test_case_step(opts = {})
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

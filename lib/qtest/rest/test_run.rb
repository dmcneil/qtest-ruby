module QTest
  module REST
    module TestRun
      include QTest::REST::Utils

      # GET '/projects/:project/test-runs/:id'
      def test_run(opts = {})
        query = QueryBuilder.new
                .project(opts[:project])
                .test_run(opts[:id])

        determine_parent!(opts)
        query.under(opts[:parent][:type], opts[:parent][:id]) if opts[:parent]
        query = query.build

        get(query)
      end

      # GET '/projects/:project/test-runs'
      def test_runs(opts = {})
        query = QueryBuilder.new
                .project(opts[:project])
                .test_runs

        determine_parent!(opts)
        query.under(opts[:parent][:type], opts[:parent][:id]) if opts[:parent]
        query = query.build

        get(query)
      end

      # POST '/projects/:project/test-runs'
      def create_test_run(opts = {})
        query = QueryBuilder.new
                .project(opts[:project])
                .test_runs
                .data(opts[:attributes])

        determine_parent!(opts)
        query.under(opts[:parent][:type], opts[:parent][:id]) if opts[:parent]
        query = query.build(:json)

        post(query)
      end

      # PUT '/projects/:project/test-runs/:id?parentType=?&parentId=?'
      def move_test_run(opts = {})
        query = QueryBuilder.new
                .project(opts[:project])
                .test_run(opts[:id])

        determine_parent!(opts)
        query.under(opts[:parent][:type], opts[:parent][:id]) if opts[:parent]
        query = query.build

        put(query)
      end

      # PUT '/projects/:project/test-runs/:id'
      def update_test_run(opts = {})
        query = QueryBuilder.new
                .project(opts[:project])
                .test_run(opts[:id])
                .data(opts[:attributes])
                .build(:json)

        put(query)
      end

      # DELETE '/projects/:project/test-runs/:id'
      def delete_test_run(opts = {})
        query = QueryBuilder.new
                .project(opts[:project])
                .test_run(opts[:id])
                .build

        delete(query)
      end

      def execution_statuses(opts = {})
        query = QueryBuilder.new
                .project(opts[:project])
                .test_runs
                .with('execution-statuses')
                .build

        get(query)
      end

      def test_run_fields(opts = {})
        query = QueryBuilder.new
                .project(opts[:project])
                .test_runs
                .with('fields')
                .build

        get(query)
      end
    end
  end
end

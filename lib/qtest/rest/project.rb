module QTest
  module REST
    module Project
      include QTest::REST::Utils

      # GET '/project/:id'
      def project(opts = {})
        query = QueryBuilder.new.project(opts[:id]).build
        get(query)
      end

      # GET '/projects'
      def projects(_opts = {})
        query = QueryBuilder.new.projects.build
        get(query)
      end
    end
  end
end

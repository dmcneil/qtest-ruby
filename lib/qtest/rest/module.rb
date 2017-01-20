module QTest
  module REST
    module Module
      include QTest::REST::Utils

      # GET '/projects/:project/modules/:id?expand=?'
      def module(opts = {})
        query = QueryBuilder.new
                .project(opts[:project])
                .module(opts[:id])
                .param('expand', opts[:expand])
                .build
        get(query)
      end

      # GET '/projects/:project/modules?parentId=?&expand=?&search=?'
      def modules(opts = {})
        query = QueryBuilder.new
                .project(opts[:project])
                .modules
                .param('parentId', opts[:module])
                .param('expand', opts[:expand])
                .param('search', opts[:search])
                .build
        get(query)
      end
    end
  end
end

module QTest
  module REST
    module Project
      include QTest::REST::Utils

      # Get a Project by ID.
      #
      # @param id [Integer] ID of the Project
      # @return [Project]
      def project(opts = {})
        query = QueryBuilder.new.project(opts[:id]).build
        get(QTest::Project, query[:path])
      end

      # Get all Projects.
      #
      # @return [Array::Project]
      def projects
        query = QueryBuilder.new.projects.build
        get(QTest::Project, query[:path])
      end
    end
  end
end

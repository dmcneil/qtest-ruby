module QTest
  module REST
    module Project
      include QTest::REST::Utils
      include QTest::REST::CRUD

      # Get a Project by ID.
      #
      # @param id [Integer] ID of the Project
      # @return [Project]
      def project(args = {})
        path = build_path('/api/v3/projects', args[:id])
        get(QTest::Project, path)
      end

      # Get all Projects.
      #
      # @return [Array::Project]
      def projects
        path = build_path('/api/v3/projects')
        get(QTest::Project, path)
      end
    end
  end
end

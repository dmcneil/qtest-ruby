module QTest
  module REST
    module Project
      include QTest::REST::Utils

      # Get a Project by ID.
      #
      # @param id [Integer] ID of the Project
      # @return [Project]
      def project(id)
        path = build_path("/api/v3", :projects, id)
        response = handle_response(self.class.get(path))
        deserialize_response(response, QTest::Project)
      end

      # Get all Projects.
      #
      # @return [Array::Project]
      def projects
        path = build_path("/api/v3", :projects)
        response = handle_response(self.class.get(path))
        deserialize_response(response, QTest::Project)
      end
    end
  end
end

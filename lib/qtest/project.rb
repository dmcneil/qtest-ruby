module QTest
  module Project
    def project(args={})
      options = {headers: auth_header}
      project_id = args[:id]
      response = self.class.get("/api/v3/projects/#{project_id}", options)

      decode_if_successful response
    end

    def projects
      options = {headers: auth_header}
      response = self.class.get("/api/v3/projects", options)

      decode_if_successful response
    end
  end
end

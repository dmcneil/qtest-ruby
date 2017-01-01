module QTest
  module Release
    def release(args={})
      options = {headers: auth_header}
      project_id = args[:project]
      release_id = args[:id]
      response = self.class.get("/api/v3/projects/#{project_id}/releases/#{release_id}", options)

      decode_if_successful response
    end

    def releases(args={})
      options = {headers: auth_header}
      project_id = args[:project]
      response = self.class.get("/api/v3/projects/#{project_id}/releases", options)

      decode_if_successful response
    end
  end
end

module QTest
  module TestRun
    def test_runs(args={})
      options = {
        headers: auth_header,
        query: {
          'parentId' => args[:release],
          'parentType' => 'release'
        }
      }
      project_id = args[:project]
      response = self.class.get("/api/v3/projects/#{project_id}/test-runs", options)

      decode_if_successful response
    end
  end
end

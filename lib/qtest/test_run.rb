module QTest
  module TestRun
    def test_run(args={})
      options = {headers: auth_header}
      response = self.class.get("/api/v3/projects/#{args[:project]}/test-runs/#{args[:id]}", options)

      decode_if_successful response
    end

    def test_runs(args={})
      options = {headers: auth_header}
      if args[:release]
        options[:query] = {
          'parentId' => args[:release],
          'parentType' => 'release'
        }
      elsif args[:test_cycle]
        options[:query] = {
          'parentId' => args[:test_cycle],
          'parentType' => 'test-cycle'
        }
      elsif args[:test_suite]
        options[:query] = {
          'parentId' => args[:test_suite],
          'parentType' => 'test-suite'
        }
      end
      response = self.class.get("/api/v3/projects/#{args[:project]}/test-runs", options)

      decode_if_successful response
    end

    def execution_statuses(args={})
      options = {headers: auth_header}
      response = self.class.get("/api/v3/projects/#{args[:project]}/test-runs/execution-statuses", options)

      decode_if_successful response
    end
  end
end

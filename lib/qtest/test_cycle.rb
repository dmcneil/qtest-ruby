module QTest
  module TestCycle
    def test_cycle(args={})
      options = {headers: auth_header}
      response = self.class.get("/api/v3/projects/#{args[:project]}/test-cycles/#{args[:id]}", options)

      decode_if_successful response
    end

    def test_cycles(args={})
      options = {headers: auth_header}
      if args[:test_cycle]
        options[:query] = {
          'parentId' => args[:test_cycle],
          'parentType' => 'test-cycle'
        }
      elsif args[:release]
        options[:query] = {
          'parentId' => args[:release],
          'parentType' => 'release'
        }
      end
      response = self.class.get("/api/v3/projects/#{args[:project]}/test-cycles", options)

      decode_if_successful response
    end

    def create_test_cycle(args={})
      options = {
        headers: auth_header
      }
      options[:headers].merge!({'Content-Type' => 'application/json'})

      options[:body] = {
        name: args[:name],
        description: args[:description]
      }

      if args[:release]
        options[:query] = {
          'parentId' => args[:release],
          'parentType' => 'release'
        }

        options[:body][:target_build_id] = args[:target_build_id]
      elsif args[:test_cycle]
        options[:query] = {
          'parentId' => args[:test_cycle],
          'parentType' => 'test-cycle'
        }
      end

      response = self.class.post("/api/v3/projects/#{args[:project]}/test-cycles", options)

      decode_if_successful response
    end
  end
end

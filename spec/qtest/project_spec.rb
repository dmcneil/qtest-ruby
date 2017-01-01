module QTest
  module Project
    def projects
      options = {
        headers: auth_header
      }
      response = self.class.get("/api/v3/projects", options)

      case response.code
      when 200
        JSON.parse(response.body, symbolize_names: true)
      end
    end
  end
end

class MockClient < QTest::Client
  include QTest::Project
end

module QTest
  describe Project do
    before do
      @client = MockClient.new
      @client.configure do |c|
        c.base_uri = "foo"
        c.token = "foobar"
      end
    end

    it 'should get all projects' do
      stub_request(:get, "http://foo/api/v3/projects")
        .with(headers: {'Authorization' => 'foobar'})
        .to_return(:status => 200,
                   :body => "[{},{}]",
                   :headers => {})

      expect(@client.projects.count).to eq 2
    end
  end
end

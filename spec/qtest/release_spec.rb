module QTest
  module Release
    def releases(args={})
      options = {
        headers: auth_header
      }
      project_id = args[:project]
      response = self.class.get("/api/v3/projects/#{project_id}/releases", options)

      case response.code
      when 200
        JSON.parse(response.body, symbolize_names: true)
      end
    end
  end
end

class MockClient < QTest::Client
  include QTest::Release
end

module QTest
  describe Release do
    before do
      @client = MockClient.new
      @client.configure do |c|
        c.base_uri = "foo"
        c.token = "foobar"
      end
    end

    it 'should get releases for a project' do
      stub_request(:get, "http://foo/api/v3/projects/1/releases")
        .with(headers: {'Authorization' => 'foobar'})
        .to_return(:status => 200, :body => "[{}, {}]", :headers => {})

      expect(@client.releases(project: 1).count).to eq 2
    end
  end
end

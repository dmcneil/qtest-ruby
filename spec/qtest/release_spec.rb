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

    it 'should get a release by id' do
      stub_request(:get, "http://foo/api/v3/projects/1/releases/5")
        .with(headers: @client.auth_header)
        .to_return(:status => 200, :body => "{}", :headers => {})

      expect(@client.release(project: 1, id: 5)).to eq({})
    end

    it 'should get releases for a project' do
      stub_request(:get, "http://foo/api/v3/projects/1/releases")
        .with(headers: @client.auth_header)
        .to_return(:status => 200, :body => "[{}, {}]", :headers => {})

      expect(@client.releases(project: 1).count).to eq 2
    end
  end
end

module QTest
  module Project
    def project(args={})
      project_id = args[:id]
      response = self.class.get("/api/v3/projects/#{project_id}", with_auth_header)

      decode_if_successful response
    end

    def projects
      response = self.class.get("/api/v3/projects", with_auth_header)

      decode_if_successful response
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

    it 'should get a project by id' do
      stub_request(:get, "http://foo/api/v3/projects/1")
        .with(headers: {'Authorization' => 'foobar'})
        .to_return(:status => 200, :body => "{}", :headers => {})

      expect(@client.project(id: 1)).to eq({})
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

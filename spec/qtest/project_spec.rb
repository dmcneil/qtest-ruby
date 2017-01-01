class MockClient < QTest::Client
end

module QTest
  describe Project do
    before do
      @client = Client.new
      @client.configure do |c|
        c.base_uri = "foo"
        c.token = "foobar"
      end
    end

    it 'should get a project by id' do
      stub_request(:get, "http://foo/api/v3/projects/1")
        .with(headers: @client.auth_header)
        .to_return(:status => 200, :body => "{}", :headers => {})

      expect(@client.project(id: 1)).to eq({})
    end

    it 'should get all projects' do
      stub_request(:get, "http://foo/api/v3/projects")
        .with(headers: @client.auth_header)
        .to_return(:status => 200,
                   :body => "[{},{}]",
                   :headers => {})

      expect(@client.projects.count).to eq 2
    end
  end
end

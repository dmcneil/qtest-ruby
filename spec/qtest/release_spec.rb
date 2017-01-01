class MockClient < QTest::Client
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

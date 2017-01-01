class MockClient < QTest::Client
end

module QTest
  describe TestRun do
    before do
      @client = MockClient.new
      @client.configure do |c|
        c.base_uri = "foo"
        c.token = "foobar"
      end
    end

    it 'should get test runs for a release' do
      stub_request(:get, "http://foo/api/v3/projects/1/test-runs")
        .with(headers: @client.auth_header, query: {
            'parentId' => 5,
            'parentType' => 'release'
        })
        .to_return(:status => 200, :body => "[{}, {}]", :headers => {})

      expect(@client.test_runs(project: 1, release: 5).count).to eq 2
    end
  end
end

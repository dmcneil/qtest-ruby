module QTest
  describe TestRun do
    before do
      @client = Client.new
      @client.configure do |c|
        c.base_uri = "foo"
        c.token = "foobar"
      end
    end

    it 'should get a test run by its id' do
      stub_request(:get, "http://foo/api/v3/projects/1/test-runs/3")
        .with(headers: @client.auth_header)
        .to_return(:status => 200, :body => "{}", :headers => {})

      expect(@client.test_run(id: 3, project: 1)).to eq({})
    end

    it 'should get all test runs for a release' do
      stub_request(:get, "http://foo/api/v3/projects/1/test-runs")
        .with(headers: @client.auth_header, query: {
            'parentId' => 5,
            'parentType' => 'release'
        })
        .to_return(:status => 200, :body => "[{}, {}]", :headers => {})

      expect(@client.test_runs(project: 1, release: 5).count).to eq 2
    end

    it 'should get all test runs for a test cycle' do
      stub_request(:get, "http://foo/api/v3/projects/1/test-runs")
        .with(headers: @client.auth_header, query: {
            'parentId' => 3,
            'parentType' => 'test-cycle'
        })
        .to_return(:status => 200, :body => "[{}]", :headers => {})

      expect(@client.test_runs(project: 1, test_cycle: 3).count).to eq 1
    end

    it 'should get all test runs for a test suite' do
      stub_request(:get, "http://foo/api/v3/projects/1/test-runs")
        .with(headers: @client.auth_header, query: {
            'parentId' => 6,
            'parentType' => 'test-suite'
        })
        .to_return(:status => 200, :body => "[{}, {}]", :headers => {})

      expect(@client.test_runs(project: 1, test_suite: 6).count).to eq 2
    end

    it 'should get execution status values' do
      stub_request(:get, "http://foo/api/v3/projects/1/test-runs/execution-statuses")
        .with(headers: @client.auth_header)
        .to_return(:status => 200, :body => "[{}, {}]", :headers => {})

      expect(@client.execution_statuses(project: 1).count).to eq 2
    end
  end
end

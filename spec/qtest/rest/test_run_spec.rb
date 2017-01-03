class Foo
  include HTTParty
  include QTest::REST::TestRun

  base_uri 'www.foo.com'
  headers 'Authorization' => 'foobar'
end

module QTest
  module REST
    describe TestRun do
      before do
        @client = Foo.new
      end

      it 'should get a test run by its id' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-runs/3')
          .with(headers: {'Authorization' => 'foobar'})
          .to_return(:status => 200, :body => '{}', :headers => {})

        expect(@client.test_run(id: 3, project: 1)).to be_a QTest::TestRun
      end

      it 'should get all test runs for a release' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-runs')
          .with(
            headers: {'Authorization' => 'foobar'},
            query: {
              'parentId' => 5,
              'parentType' => 'release'
          })
          .to_return(:status => 200, :body => '[{}, {}]', :headers => {})

        test_runs = @client.test_runs(project: 1, release: 5)

        expect(test_runs.count).to eq 2
        expect(test_runs[0]).to be_a QTest::TestRun
        expect(test_runs[1]).to be_a QTest::TestRun
      end

      it 'should get all test runs for a test cycle' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-runs')
          .with(
          headers: {'Authorization' => 'foobar'},
          query: {
              'parentId' => 3,
              'parentType' => 'test-cycle'
          })
          .to_return(:status => 200, :body => '[{}]', :headers => {})

        test_runs = @client.test_runs(project: 1, test_cycle: 3)

        expect(test_runs.count).to eq 1
        expect(test_runs.first).to be_a QTest::TestRun
      end

      it 'should get all test runs for a test suite' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-runs')
          .with(
          headers: {'Authorization' => 'foobar'},
          query: {
              'parentId' => 6,
              'parentType' => 'test-suite'
          })
          .to_return(:status => 200, :body => '[{}, {}]', :headers => {})

        test_runs = @client.test_runs(project: 1, test_suite: 6)

        expect(test_runs.count).to eq 2
        expect(test_runs[0]).to be_a QTest::TestRun
        expect(test_runs[1]).to be_a QTest::TestRun
      end

      it 'should get execution status values' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-runs/execution-statuses')
          .with(headers: {'Authorization' => 'foobar'})
          .to_return(:status => 200, :body => '[{}, {}]', :headers => {})

        expect(@client.execution_statuses(project: 1).count).to eq 2
      end
    end
  end
end

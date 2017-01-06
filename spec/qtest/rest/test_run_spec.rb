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
          .with(headers: { 'Authorization' => 'foobar' })
          .to_return(status: 200, body: '{}')

        expect(@client.test_run(id: 3, project: 1)).to be_a QTest::TestRun
      end

      it 'should get all test runs for a release' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-runs')
          .with(
            query: {
              'parentId' => 5,
              'parentType' => 'release'
            },
            headers: { 'Authorization' => 'foobar' }
          )
          .to_return(status: 200, body: '[{}, {}]')

        test_runs = @client.test_runs(project: 1, release: 5)

        expect(test_runs.count).to eq 2
        expect(test_runs[0]).to be_a QTest::TestRun
        expect(test_runs[1]).to be_a QTest::TestRun
      end

      it 'should get all test runs for a test cycle' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-runs')
          .with(
            query: {
              'parentId' => 3,
              'parentType' => 'test-cycle'
            },
            headers: { 'Authorization' => 'foobar' }
          )
          .to_return(status: 200, body: '[{}]')

        test_runs = @client.test_runs(project: 1, test_cycle: 3)

        expect(test_runs.count).to eq 1
        expect(test_runs.first).to be_a QTest::TestRun
      end

      it 'should get all test runs for a test suite' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-runs')
          .with(
            query: {
              'parentId' => 6,
              'parentType' => 'test-suite'
            },
            headers: { 'Authorization' => 'foobar' }
          )
          .to_return(status: 200, body: '[{}, {}]')

        test_runs = @client.test_runs(project: 1, test_suite: 6)

        expect(test_runs.count).to eq 2
        expect(test_runs[0]).to be_a QTest::TestRun
        expect(test_runs[1]).to be_a QTest::TestRun
      end

      it 'should create a test run under a release' do
        stub_request(:post, 'http://www.foo.com/api/v3/projects/1/test-runs')
          .with(
            query: {
              'parentId' => 2,
              'parentType' => 'release'
            },
            headers: {
              'Authorization' => 'foobar',
              'Content-Type' => 'application/json'
            },
            body: {
              name: 'Run 1',
              test_case: {
                test_case_version_id: 5
              }
            }.to_json
          )
          .to_return(status: 200, body: '{}')

        test_run = {
          project: 1,
          release: 2,
          name: 'Run 1',
          test_case: {
            test_case_version_id: 5
          }
        }

        expect(@client.create_test_run(test_run)).to be_a QTest::TestRun
      end

      it 'should create a test run under a test cycle' do
        stub_request(:post, 'http://www.foo.com/api/v3/projects/1/test-runs')
          .with(
            query: {
              'parentId' => 2,
              'parentType' => 'test-cycle'
            },
            headers: {
              'Authorization' => 'foobar',
              'Content-Type' => 'application/json'
            },
            body: {
              name: 'Run 1',
              test_case: {
                test_case_version_id: 5
              }
            }.to_json
          )
          .to_return(status: 200, body: '{}')

        test_run = {
          project: 1,
          test_cycle: 2,
          name: 'Run 1',
          test_case: {
            test_case_version_id: 5
          }
        }

        expect(@client.create_test_run(test_run)).to be_a QTest::TestRun
      end

      it 'should create a test run under a test suite' do
        stub_request(:post, 'http://www.foo.com/api/v3/projects/1/test-runs')
          .with(
            query: {
              'parentId' => 2,
              'parentType' => 'test-suite'
            },
            headers: {
              'Authorization' => 'foobar',
              'Content-Type' => 'application/json'
            },
            body: {
              name: 'Run 1',
              test_case: {
                test_case_version_id: 5
              }
            }.to_json
          )
          .to_return(status: 200, body: '{}')

        test_run = {
          project: 1,
          test_suite: 2,
          name: 'Run 1',
          test_case: {
            test_case_version_id: 5
          }
        }

        expect(@client.create_test_run(test_run)).to be_a QTest::TestRun
      end

      it 'should move a test run to another release' do
        stub_request(:put, 'http://www.foo.com/api/v3/projects/1/test-runs/9')
          .with(
            headers: { 'Authorization' => 'foobar' },
            query: {
              'parentId' => 6,
              'parentType' => 'release'
            }
          )
          .to_return(status: 200, body: '{}')

        expect(@client.move_test_run(id: 9,
                                     project: 1,
                                     release: 6)).to be_a QTest::TestRun
      end

      it 'should update a test run' do
        stub_request(:put, 'http://www.foo.com/api/v3/projects/1/test-runs/9')
          .with(
            headers: { 'Authorization' => 'foobar' },
            body: {
              name: 'New name'
            }.to_json
          )
          .to_return(status: 200, body: '{}')

        expect(@client.update_test_run(id: 9,
                                       project: 1,
                                       name: 'New name')).to be_a QTest::TestRun
      end

      it 'should delete a test run' do
        stub_request(:delete, 'http://www.foo.com/api/v3/projects/1/test-runs/4')
          .with(
            headers: { 'Authorization' => 'foobar' }
          )
          .to_return(status: 200, body: '{}')

        expect do
          @client.delete_test_run(id: 4, project: 1)
        end.to_not raise_error
      end

      it 'should get execution status values' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-runs/execution-statuses')
          .with(headers: { 'Authorization' => 'foobar' })
          .to_return(status: 200, body: '[{}, {}]')

        expect(@client.execution_statuses(project: 1).count).to eq 2
      end

      it 'should get test run fields' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-runs/fields')
          .with(headers: { 'Authorization' => 'foobar' })
          .to_return(status: 200, body: '[{}, {}]')

        fields = @client.test_run_fields(project: 1)

        expect(fields.count).to be 2
      end
    end
  end
end

class Foo
  include HTTParty
  include QTest::REST::TestSuite

  base_uri 'www.foo.com'
  headers 'Authorization' => 'foobar'
end

module QTest
  module REST
    describe TestSuite do
      before do
        @client = Foo.new
      end

      it 'should get a test suite by id' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-suites/5')
          .with(headers: { 'Authorization' => 'foobar' })
          .to_return(status: 200, body: '{}')

        expect(@client.test_suite(project: 1, id: 5)).to eq({})
      end

      it 'should get all test suites for a release' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-suites')
          .with(
            query: {
              'parentId' => 5,
              'parentType' => 'release'
            },
            headers: { 'Authorization' => 'foobar' }
          )
          .to_return(status: 200, body: '[{}, {}]')

        test_suites = @client.test_suites(project: 1, release: 5)

        expect(test_suites).to eq([{}, {}])
      end

      it 'should get all test suites for a test cycle' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-suites')
          .with(
            query: {
              'parentId' => 3,
              'parentType' => 'test-cycle'
            },
            headers: { 'Authorization' => 'foobar' }
          )
          .to_return(status: 200, body: '[{}, {}]')

        test_suites = @client.test_suites(project: 1, test_cycle: 3)

        expect(test_suites).to eq([{}, {}])
      end

      it 'should create a test suite under a test cycle' do
        stub_request(:post, 'http://www.foo.com/api/v3/projects/1/test-suites')
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
              name: 'Suite 1'
            }.to_json
          )
          .to_return(status: 200, body: '{}')

        test_suite = {
          project: 1,
          test_cycle: 2,
          attributes: {
            name: 'Suite 1'
          }
        }

        expect(@client.create_test_suite(test_suite)).to eq({})
      end

      it 'should create a test suite under a release' do
        stub_request(:post, 'http://www.foo.com/api/v3/projects/1/test-suites')
          .with(
            query: {
              'parentId' => 2,
              'parentType' => 'release'
            },
            headers: {
              'Authorization' => 'foobar'
            },
            body: {
              name: 'Release 1',
              properties: [],
              target_build_id: 123,
            }.to_json
          )
          .to_return(status: 200, body: '{}')

        test_suite = {
          project: 1,
          release: 2,
          attributes: {
            name: 'Release 1',
            properties: [],
            target_build_id: 123
          }
        }

        expect(@client.create_test_suite(test_suite)).to eq({})
      end

      it 'should move a test suite to another test cycle' do
        stub_request(:put, 'http://www.foo.com/api/v3/projects/1/test-suites/2')
          .with(
            query: {
              'parentId' => '5',
              'parentType' => 'test-cycle'
            },
            headers: {
              'Authorization' => 'foobar'
            }
          )
          .to_return(status: 200, body: '{}')

          test_suite = @client.move_test_suite({
            project: 1,
            id: 2,
            test_cycle: 5
          })

          expect(test_suite).to eq({})
      end

      it 'should move a test suite to another release' do
        stub_request(:put, 'http://www.foo.com/api/v3/projects/1/test-suites/2')
          .with(
            query: {
              'parentId' => '5',
              'parentType' => 'release'
            },
            headers: {
              'Authorization' => 'foobar'
            }
          )
          .to_return(status: 200, body: '{}')

          test_suite = @client.move_test_suite({
            project: 1,
            id: 2,
            release: 5
          })

          expect(test_suite).to eq({})
      end

      it 'should update a test suite' do
        stub_request(:put, 'http://www.foo.com/api/v3/projects/1/test-suites/2')
          .with(
            body: {
              name: 'New name',
              properties: [{
                field_id: 1,
                field_value: 'New value'
              }]
            }.to_json,
            headers: {
              'Authorization' => 'foobar',
              'Content-Type' => 'application/json'
            }
          )
          .to_return(status: 200, body: '{}')

        test_suite = @client.update_test_suite({
          project: 1,
          id: 2,
          attributes: {
            name: 'New name',
            properties: [
              {
                field_id: 1,
                field_value: 'New value'
              }
            ]
          }
        })

        expect(test_suite).to eq({})
      end
    end
  end
end

class Foo
  include HTTParty
  include QTest::REST::TestCase

  base_uri 'www.foo.com'
  headers 'Authorization' => 'foobar'
end

module QTest
  module REST
    describe TestCase do
      before do
        @client = Foo.new
      end

      it 'should get a test case by id' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-cases/5')
          .with(headers: { 'Authorization' => 'foobar' })
          .to_return(status: 200, body: '{}')

        expect(@client.test_case(project: 1, id: 5)).to eq({})
      end

      it 'should get all test cases for a release' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-cases')
          .with(
            query: {
              'parentId' => 5,
              'parentType' => 'release',
              'page' => 1
            },
            headers: { 'Authorization' => 'foobar' }
          )
          .to_return(status: 200, body: '[{}, {}]')

        test_cases = @client.test_cases(project: 1, release: 5)

        expect(test_cases).to eq([{}, {}])
      end

      it 'should get all test cases for a test cycle' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-cases')
          .with(
            query: {
              'parentId' => 3,
              'parentType' => 'test-cycle',
              'page' => 1
            },
            headers: { 'Authorization' => 'foobar' }
          )
          .to_return(status: 200, body: '[{}, {}]')

        test_cases = @client.test_cases(project: 1, test_cycle: 3)

        expect(test_cases).to eq([{}, {}])
      end

      it 'should create a test case under a test cycle' do
        stub_request(:post, 'http://www.foo.com/api/v3/projects/1/test-cases')
          .with(
            query: {
              'parentId' => 2,
              'parentType' => 'test-cycle',
              'page' => 1
            },
            headers: {
              'Authorization' => 'foobar',
              'Content-Type' => 'application/json'
            },
            body: {
              name: 'Suite 1',
              properties: []
            }.to_json
          )
          .to_return(status: 200, body: '{}')

        test_case = {
          project: 1,
          test_cycle: 2,
          name: 'Suite 1'
        }

        expect(@client.create_test_case(test_case)).to be_a QTest::TestSuite
      end

      it 'should create a test case under a release' do
        stub_request(:post, 'http://www.foo.com/api/v3/projects/1/test-cases')
          .with(
            query: {
              'parentId' => 2,
              'parentType' => 'release',
              'page' => 1
            },
            headers: {
              'Authorization' => 'foobar',
              'Content-Type' => 'application/json'
            },
            body: {
              name: 'Test case 1',
              description: 'Case desc',
              properties: []
            }.to_json
          )
          .to_return(status: 200, body: '{}')

        test_case = {
          project: 1,
          release: 2,
          name: 'Test case 1',
          description: 'Case desc'
        }

        expect(@client.create_test_case(test_case)).to eq({})
      end

      it 'should update a test case' do
        stub_request(:put, 'http://www.foo.com/api/v3/projects/1/test-cases/2')
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

        test_case = @client.update_test_case({
          project: 1,
          test_case: 2,
          name: 'New name',
          properties: [
            {
              field_id: 1,
              field_value: 'New value'
            }
          ]
        })

        expect(test_case).to be_a QTest::TestSuite
      end
    end
  end
end

class Foo
  include HTTParty
  include QTest::REST::API
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

      it 'should get all test cases under a module' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-cases')
          .with(headers: { 'Authorization' => 'foobar' },
                query: {
                  'parentId' => 1
                })
          .to_return(status: 200, body: '[{}]')

        expect(@client.test_cases(project: 1, module: 1)).to eq([{}])
      end

      it 'should get a specific version of a test case' do
        stub_request(:get,
                     'http://www.foo.com/api/v3/projects/1/test-cases/2/versions/3')
          .with(headers: { 'Authorization' => 'foobar' })
          .to_return(status: 200, body: '{}')

        expect(@client.test_case_version(project: 1, test_case: 2, version: 3))
          .to eq({})
      end

      it 'should get all versions of a test case' do
        stub_request(:get,
                     'http://www.foo.com/api/v3/projects/1/test-cases/2/versions')
          .with(headers: { 'Authorization' => 'foobar' })
          .to_return(status: 200, body: '[{}]')

        expect(@client.test_case_versions(project: 1, test_case: 2))
          .to eq([{}])
      end

      it 'should get a test step by id' do
        stub_request(:get,
                     'http://www.foo.com/api/v3/projects/1/test-cases/2/test-steps/3')
          .with(headers: { 'Authorization' => 'foobar' })
          .to_return(status: 200, body: '{}')

        expect(@client.test_step(project: 1, test_case: 2, id: 3))
          .to eq({})
      end

      it 'should get all test case fields' do
        stub_request(:get,
                     'http://www.foo.com/api/v3/projects/1/settings/test-cases/fields')
          .with(headers: { 'Authorization' => 'foobar' })
          .to_return(status: 200, body: '[{}]')

        expect(@client.fields(project: 1, type: :test_cases)).to eq([{}])
      end
    end
  end
end

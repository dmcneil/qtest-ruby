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
                    .with(headers: {'Authorization' => 'foobar'})
                    .to_return(status: 200, body: '{}')

        expect(@client.test_suite(project: 1, id: 5)).to be_a QTest::TestSuite
      end

      it 'should get all test suites for a release' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-suites')
                    .with(
                      query: {
                        'parentId' => 5,
                        'parentType' => 'release'
                      },
                      headers: {'Authorization' => 'foobar'}
                    )
                    .to_return(status: 200, body: '[{}, {}]')

        test_suites = @client.test_suites(project: 1, release: 5)

        expect(test_suites.count).to eq 2
        expect(test_suites[0]).to be_a QTest::TestSuite
        expect(test_suites[1]).to be_a QTest::TestSuite
      end

      it 'should get all test suites for a test cycle' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-suites')
                    .with(
                      query: {
                        'parentId' => 3,
                        'parentType' => 'test-cycle'
                      },
                      headers: {'Authorization' => 'foobar'}
                    )
                    .to_return(status: 200, body: '[{}, {}]')

        test_suites = @client.test_suites(project: 1, test_cycle: 3)

        expect(test_suites.count).to eq 2
        expect(test_suites[0]).to be_a QTest::TestSuite
        expect(test_suites[1]).to be_a QTest::TestSuite
      end

      it 'should create a test suite under a test cycle' do
        stub_request(:post, 'http://www.foo.com/api/v3/projects/1/test-suites')
          .with(
            query: {
              'parentId' => 2,
              'parentType' => 'test-cycle'
            },
            headers: {
              'Authorization'=>'foobar',
              'Content-Type'=>'application/json'
            },
            body: {
              name: 'Suite 1'
            }.to_json
          )
          .to_return(status: 200, body: '{}')

        test_suite = {
          project: 1,
          test_cycle: 2,
          name: 'Suite 1'
        }

        expect(@client.create_test_suite(test_suite)).to be_a QTest::TestSuite
      end

      it 'should create a test suite under a release' do
        stub_request(:post, 'http://www.foo.com/api/v3/projects/1/test-suites')
          .with(
            query: {
              'parentId' => 2,
              'parentType' => 'release'
            },
            headers: {
              'Authorization'=>'foobar',
              'Content-Type'=>'application/json'
            },
            body: {
              name: 'Release 1',
              target_build_id: 123
            }.to_json
          )
          .to_return(status: 200, body: '{}')

        release = {
          project: 1,
          release: 2,
          name: 'Release 1',
          target_build: 123
        }

        expect(@client.create_test_suite(release)).to be_a QTest::TestSuite
      end
    end
  end
end

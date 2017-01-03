class Foo
  include HTTParty
  include QTest::REST::TestCycle

  base_uri 'www.foo.com'
  headers 'Authorization' => 'foobar'
end

module QTest
  module REST
    describe TestCycle do
      before do
        @client = Foo.new
      end

      it 'should get a test cycle by id' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-cycles/3')
          .with(headers: {'Authorization' => 'foobar'})
          .to_return(:status => 200, :body => '{}', :headers => {})

        expect(@client.test_cycle(project: 1, id: 3)).to be_a QTest::TestCycle
      end

      it 'should get all test cycles under a release' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-cycles')
          .with(
            headers: {'Authorization' => 'foobar'},
            query: {
              'parentId' => 2,
              'parentType' => 'release'
            }
          )
          .to_return(:status => 200, :body => '[{}, {}]', :headers => {})

        test_cycles = @client.test_cycles(project: 1, release: 2)

        expect(test_cycles.count).to eq 2
        expect(test_cycles[0]).to be_a QTest::TestCycle
        expect(test_cycles[1]).to be_a QTest::TestCycle
      end

      it 'should get all test cycles under a test cycle' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-cycles')
          .with(
            headers: {'Authorization' => 'foobar'},
            query: {
              'parentId' => 4,
              'parentType' => 'test-cycle'
            }
          )
          .to_return(:status => 200, :body => '[{}, {}, {}]', :headers => {})

        expect(@client.test_cycles(project: 1, test_cycle: 4).count).to eq 3
      end

      it 'should create a test cycle under a release' do
        stub_request(:post, 'http://www.foo.com/api/v3/projects/1/test-cycles?parentId=2&parentType=release')
          .with(body: 'name=Cycle%201&description=Create%20a%20foo%20cycle&target_build_id=15332',
                headers: {'Authorization'=>'foobar', 'Content-Type'=>'application/json'})
          .to_return(:status => 200, :body => '{}', :headers => {})

        test_cycle = {
          project: 1,
          release: 2,
          name: 'Cycle 1',
          description: 'Create a foo cycle',
          target_build_id: 15332
        }

        expect(@client.create_test_cycle(test_cycle)).to be_a QTest::TestCycle
      end
    end
  end
end

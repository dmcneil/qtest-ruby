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
          target_build: 15332
        }

        expect(@client.create_test_cycle(test_cycle)).to be_a QTest::TestCycle
      end

      it 'should move a test cycle to another test cycle' do
        stub_request(:put, 'http://www.foo.com/api/v3/projects/1/test-cycles/9')
          .with(
            headers: {'Authorization' => 'foobar'},
            query: {
              'parentId' => 4,
              'parentType' => 'test-cycle'
            }
          )
          .to_return(:status => 200, :body => '{}', :headers => {})

        expect(@client.move_test_cycle(id: 9, project: 1, test_cycle: 4)).to be_a QTest::TestCycle
      end

      it 'should move a test cycle to another release' do
        stub_request(:put, 'http://www.foo.com/api/v3/projects/1/test-cycles/9')
          .with(
            headers: {'Authorization' => 'foobar'},
            query: {
              'parentId' => 6,
              'parentType' => 'release'
            }
          )
          .to_return(:status => 200, :body => '{}', :headers => {})

        expect(@client.move_test_cycle(id: 9, project: 1, release: 6)).to be_a QTest::TestCycle
      end

      it 'should update a test cycle' do
        stub_request(:put, 'http://www.foo.com/api/v3/projects/1/test-cycles/9')
          .with(
            headers: {'Authorization' => 'foobar'},
            body: "name=New%20name&description=New%20description"
          )
          .to_return(:status => 200, :body => '{}', :headers => {})

        expect(@client.update_test_cycle({
          id: 9,
          project: 1,
          name: 'New name',
          description: 'New description'
        })).to be_a QTest::TestCycle
      end

      it 'should delete a test cycle' do
        stub_request(:delete, 'http://www.foo.com/api/v3/projects/1/test-cycles/9')
          .with(
            headers: {'Authorization' => 'foobar'},
            query: {
              force: false
            }
          )
          .to_return(:status => 200, :body => '{}', :headers => {})

        expect {
          @client.delete_test_cycle(id: 9, project: 1)
        }.to_not raise_error
      end

      it 'should force delete a test cycle' do
        stub_request(:delete, 'http://www.foo.com/api/v3/projects/1/test-cycles/9')
          .with(
            headers: {'Authorization' => 'foobar'},
            query: {
              force: true
            }
          )
          .to_return(:status => 200, :body => '{}', :headers => {})

        expect {
          @client.delete_test_cycle(id: 9, project: 1, force: true)
        }.to_not raise_error
      end
    end
  end
end

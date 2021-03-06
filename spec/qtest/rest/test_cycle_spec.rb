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
          .with(headers: { 'Authorization' => 'foobar' })
          .to_return(status: 200, body: '{}')

        expect(@client.test_cycle(project: 1, id: 3)).to eq({})
      end

      it 'should get all test cycles under a release' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-cycles')
          .with(
            headers: { 'Authorization' => 'foobar' },
            query: {
              'parentId' => 2,
              'parentType' => 'release'
            }
          )
          .to_return(status: 200, body: '[{}, {}]')

        test_cycles = @client.test_cycles(project: 1, release: 2)

        expect(test_cycles).to eq([{}, {}])
      end

      it 'should get all test cycles under a test cycle' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/test-cycles')
          .with(
            headers: { 'Authorization' => 'foobar' },
            query: {
              'parentId' => 4,
              'parentType' => 'test-cycle'
            }
          )
          .to_return(status: 200, body: '[{}, {}, {}]', headers: {})

        test_cycles = @client.test_cycles(project: 1, test_cycle: 4)

        expect(test_cycles).to eq([{}, {}, {}])
      end

      it 'should create a test cycle under a release' do
        stub_request(:post, 'http://www.foo.com/api/v3/projects/1/test-cycles')
          .with(
            query: {
              'parentId' => 2,
              'parentType' => 'release'
            },
            body: {
              name: 'Cycle 1',
              description: 'Create a foo cycle',
              target_build_id: 15_332
            }.to_json,
            headers: {
              'Authorization' => 'foobar',
              'Content-Type' => 'application/json'
            }
          )
          .to_return(status: 200, body: '{}')

        test_cycle = {
          project: 1,
          release: 2,
          attributes: {
            name: 'Cycle 1',
            description: 'Create a foo cycle',
            target_build_id: 15_332
          }
        }

        expect(@client.create_test_cycle(test_cycle)).to eq({})
      end

      it 'should move a test cycle to another test cycle' do
        stub_request(:put, 'http://www.foo.com/api/v3/projects/1/test-cycles/9')
          .with(
            headers: { 'Authorization' => 'foobar' },
            query: {
              'parentId' => 4,
              'parentType' => 'test-cycle'
            }
          )
          .to_return(status: 200, body: '{}')

        test_cycle = @client.move_test_cycle(id: 9, project: 1, test_cycle: 4)

        expect(test_cycle).to eq({})
      end

      it 'should move a test cycle to another release' do
        stub_request(:put, 'http://www.foo.com/api/v3/projects/1/test-cycles/9')
          .with(
            headers: { 'Authorization' => 'foobar' },
            query: {
              'parentId' => 6,
              'parentType' => 'release'
            }
          )
          .to_return(status: 200, body: '{}')

        test_cycle = @client.move_test_cycle(id: 9, project: 1, release: 6)

        expect(test_cycle).to eq({})
      end

      it 'should update a test cycle' do
        stub_request(:put, 'http://www.foo.com/api/v3/projects/1/test-cycles/9')
          .with(
            headers: {
              'Authorization' => 'foobar',
              'Content-Type' => 'application/json'
            },
            body: {
              name: 'New name',
              description: 'New description'
            }.to_json
          )
          .to_return(status: 200, body: '{}')

        test_cycle = @client.update_test_cycle(id: 9,
                                               project: 1,
                                               attributes: {
                                                 name: 'New name',
                                                 description: 'New description'
                                               })

        expect(test_cycle).to eq({})
      end

      it 'should delete a test cycle' do
        stub_request(:delete, 'http://www.foo.com/api/v3/projects/1/test-cycles/9')
          .with(
            headers: { 'Authorization' => 'foobar' }
          )
          .to_return(status: 200, body: '{}')

        expect do
          @client.delete_test_cycle(id: 9, project: 1)
        end.to_not raise_error
      end

      it 'should force delete a test cycle' do
        stub_request(:delete, 'http://www.foo.com/api/v3/projects/1/test-cycles/9')
          .with(
            headers: { 'Authorization' => 'foobar' },
            query: {
              force: true
            }
          )
          .to_return(status: 200, body: '{}')

        expect do
          @client.delete_test_cycle(id: 9, project: 1, force: true)
        end.to_not raise_error
      end
    end
  end
end

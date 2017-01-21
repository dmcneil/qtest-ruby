class Foo
  include HTTParty
  include QTest::REST::Module

  base_uri 'www.foo.com'
  headers 'Authorization' => 'foobar'
end

module QTest
  module REST
    describe Module do
      before do
        @client = Foo.new
      end

      it 'should get a module by id' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/modules/2')
          .with(headers: { 'Authorization' => 'foobar' })
          .to_return(status: 200, body: '{}')

        expect(@client.module(project: 1, id: 2)).to eq({})
      end

      it 'should get a module by id with descendants expanded' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/modules/2')
          .with(headers: { 'Authorization' => 'foobar' },
                query: {
                  'expand' => 'descendants'
                })
          .to_return(status: 200, body: '{}')

        project_module = @client.module(project: 1,
                                        id: 2,
                                        expand: 'descendants')

        expect(project_module).to eq({})
      end

      it 'should search for modules by name' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/modules')
          .with(headers: { 'Authorization' => 'foobar' },
                query: {
                  'search' => 'foo'
                })
          .to_return(status: 200, body: '[{}, {}]')

        project_modules = @client.modules(project: 1, search: 'foo')

        expect(project_modules).to eq([{}, {}])
      end

      it 'should get all modules under root' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/modules')
          .with(headers: { 'Authorization' => 'foobar' })
          .to_return(status: 200, body: '[{}, {}]')

        project_modules = @client.modules(project: 1)

        expect(project_modules).to eq([{}, {}])
      end

      it 'should get all modules under a parent' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/modules')
          .with(headers: { 'Authorization' => 'foobar' },
                query: {
                  'parentId' => 5
                })
          .to_return(status: 200, body: '[{}]')

        expect(@client.modules(project: 1, module: 5)).to eq([{}])
      end

      it 'should get all modules with descendants expanded' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/modules')
          .with(headers: { 'Authorization' => 'foobar' },
                query: {
                  'parentId' => 5,
                  'expand' => 'descendants'
                })
          .to_return(status: 200, body: '[{}]')

        project_modules = @client.modules(project: 1,
                                          module: 5,
                                          expand: 'descendants')

        expect(project_modules).to eq([{}])
      end
    end
  end
end

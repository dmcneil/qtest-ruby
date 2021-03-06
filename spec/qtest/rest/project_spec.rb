class Foo
  include HTTParty
  include QTest::REST::Project

  base_uri 'www.foo.com'
  headers 'Authorization' => 'foobar'
end

module QTest
  module REST
    describe Project do
      before do
        @client = Foo.new
      end

      it 'should get a project by id' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1')
          .with(headers: { 'Authorization' => 'foobar' })
          .to_return(status: 200, body: '{}')

        expect(@client.project(id: 1)).to eq({})
      end

      it 'should get all projects' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects')
          .with(headers: { 'Authorization' => 'foobar' })
          .to_return(status: 200, body: '[{}, {}]')

        projects = @client.projects

        expect(projects.count).to eq 2
        expect(projects[0]).to eq({})
        expect(projects[1]).to eq({})
      end
    end
  end
end

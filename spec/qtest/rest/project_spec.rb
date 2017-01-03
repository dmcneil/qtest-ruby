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
          .with(headers: {'Authorization' => 'foobar'})
          .to_return(:status => 200, :body => '{}', :headers => {})

        expect(@client.project(1)).to be_a QTest::Project
      end

      it 'should get all projects' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects')
          .with(headers: {'Authorization' => 'foobar'})
          .to_return(:status => 200,
                     :body => '[{},{}]',
                     :headers => {})

        projects = @client.projects

        expect(projects.count).to eq 2
        expect(projects[0]).to be_a QTest::Project
        expect(projects[1]).to be_a QTest::Project
      end
    end
  end
end

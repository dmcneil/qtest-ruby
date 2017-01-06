class Foo
  include HTTParty
  include QTest::REST::Release

  base_uri 'www.foo.com'
  headers 'Authorization' => 'foobar'
end

module QTest
  module REST
    describe Release do
      before do
        @client = Foo.new
      end

      it 'should get a release by id' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/releases/5')
          .with(headers: { 'Authorization' => 'foobar' })
          .to_return(status: 200, body: '{}')

        expect(@client.release(project: 1, id: 5)).to be_a QTest::Release
      end

      it 'should get all releases for a project' do
        stub_request(:get, 'http://www.foo.com/api/v3/projects/1/releases')
          .with(headers: { 'Authorization' => 'foobar' })
          .to_return(status: 200, body: '[{}, {}]')

        expect(@client.releases(project: 1).count).to eq 2
      end
    end
  end
end

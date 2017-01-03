class Foo < QTest::Client
end

module QTest
  module REST
    describe API do
      describe "authentication" do
        before do
          @client = Foo.new
          @client.base_uri = "http://www.foo.com"
        end

        it "should set the token if successful" do
          stub_request(:post, "http://www.foo.com/api/login")
            .with(:body => {"j_password"=>"bar", "j_username"=>"foo"},
                  :headers => {'Content-Type'=>'application/x-www-form-urlencoded'})
            .to_return(:status => 200, :body => "foobar", :headers => {})

          @client.auth 'foo', 'bar'

          expect(@client.token).to eq "foobar"
        end

        it "should raise an AuthorizationError if failed" do
          stub_request(:post, "http://www.foo.com/api/login")
            .with(:body => {"j_password"=>"bar", "j_username"=>"foo"},
                  :headers => {'Content-Type'=>'application/x-www-form-urlencoded'})
            .to_return(:status => 401, :body => "Invalid username/password.", :headers => {})

            expect {
              @client.auth 'foo', 'bar'
            }.to raise_error(AuthorizationError, "Invalid username/password.")
        end
      end
    end
  end
end

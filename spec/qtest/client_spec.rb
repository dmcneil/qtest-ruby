module QTest
  describe Client do
    before do
      @client = Client.new
    end

    describe "configuration" do
      it "should set the base uri" do
        @client.configure do |c|
          c.base_uri = "http://www.foo.com"
        end

        expect(Client.base_uri).to eq "http://www.foo.com"
      end
    end

    describe "authentication" do
      before do
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
          .to_return(:status => 401, :body => "", :headers => {})

          expect {
            @client.auth 'foo', 'bar'
          }.to raise_error(AuthorizationError, "Invalid username/password.")
      end
    end
  end
end

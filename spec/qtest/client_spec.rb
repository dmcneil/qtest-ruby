module QTest
  describe Client do
    before do
      @client = QTest::Client.new
    end

    describe 'configuration' do
      it 'should set the base uri' do
        @client.configure do |c|
          c.base_uri = 'http://www.foo.com'
        end

        expect(Client.base_uri).to eq 'http://www.foo.com'
      end
    end
  end
end

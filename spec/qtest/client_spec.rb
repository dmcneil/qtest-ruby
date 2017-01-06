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

    describe 'defining the client on QTest::Base' do
      it 'should define the client for the QTest::Base class' do
        expect(QTest::Base).to respond_to :client
      end

      it 'should raise an error if no client has been created' do
        QTest::Base.singleton_class.send(:undef_method, :client)

        expect do
          QTest::Base.client
        end.to raise_error QTest::Error, 'No QTest::Client found. Create one using QTest::Client.new first.'
      end
    end
  end
end

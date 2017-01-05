class StubClient < QTest::Client
end

module QTest
  describe TestSuite do
    before do
      @client = StubClient.new
    end
  end
end

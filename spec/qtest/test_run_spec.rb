module QTest
  describe TestRun do
    before do
      @client = QTest::Client.new
      @project = QTest::Project.new(id: 1)
      @test_run = QTest::TestRun.new(id: 2, project: @project)
    end
  end
end

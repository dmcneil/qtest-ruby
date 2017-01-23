module QTest
  describe TestRun do
    before do
      @client = QTest::Client.new
      @project = QTest::Project.new(id: 1)
      @test_run = QTest::TestRun.new(id: 2, project: @project)
    end

    it 'should submit a test log' do
      expect(@client).to receive(:submit_test_log)
        .with(project: 1,
              test_run: 2,
              attributes: {
                status: { id: 600 },
                exe_start_date: 'Now',
                exe_end_date: 'Then'
              })
        .and_return({})

      @test_run.submit_test_log(status: { id: 600 },
                                exe_start_date: 'Now',
                                exe_end_date: 'Then')
    end
  end
end

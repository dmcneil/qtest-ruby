class StubClient < QTest::Client
end

module QTest
  describe TestSuite do
    before do
      @client = StubClient.new
      @project = QTest::Project.new(id: 1)
      @release = QTest::Release.new(id: 2, project: @project)
      @test_suite = QTest::TestSuite.new(id: 3,
                                         project: @project,
                                         release: @release)
      @test_run = QTest::TestRun.new(id: 5)
    end

    describe 'test runs' do
      it 'should get all test runs' do
        expect(@client).to receive(:test_runs)
          .with(project: 1, test_suite: 3)
          .and_return([@test_run])

        test_runs = @test_suite.test_runs

        expect(test_runs).to be_a Array
        expect(test_runs.first).to eq @test_run
        expect(test_runs.first.release).to eq @release
        expect(test_runs.first.project).to eq @project
        expect(test_runs.first.test_suite).to eq @test_suite
      end

      it 'should return an empty array if none found' do
        expect(@client).to receive(:test_runs)
          .with(project: 1, test_suite: 3)
          .and_return([])

        expect(@test_suite.test_runs).to eq []
      end
    end
  end
end

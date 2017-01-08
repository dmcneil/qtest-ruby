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

    it 'should move a test suite to another test cycle' do
      test_cycle = QTest::TestCycle.new(id: 2)

      expect(@client).to receive(:move_test_suite)
        .with(project: 1, test_cycle: 2, test_suite: @test_suite.id)
        .and_return(@test_suite)
      expect(@client).to receive(:test_cycle)
        .with(project: 1, test_cycle: 2)
        .and_return(test_cycle)

      expect(@test_suite.move(test_cycle: 2)).to eq @test_suite
      expect(@test_suite.test_cycle).to eq test_cycle
    end

    it 'should move a test suite to another release' do
      release = QTest::Release.new(id: 2)

      expect(@client).to receive(:move_test_suite)
        .with(project: 1, release: 2, test_suite: @test_suite.id)
        .and_return(@test_suite)
      expect(@client).to receive(:release)
        .with(project: 1, release: 2)
        .and_return(release)

      expect(@test_suite.move(release: 2)).to eq @test_suite
      expect(@test_suite.release).to eq release
    end
  end
end

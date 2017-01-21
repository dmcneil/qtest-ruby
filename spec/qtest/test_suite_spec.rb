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
    end

    describe 'test runs' do
      it 'should get all test runs' do
        expect(@client).to receive(:test_runs)
          .with(project: 1, test_suite: 3)
          .and_return([{}])

        test_runs = @test_suite.test_runs

        expect(test_runs).to be_a Array
        expect(test_runs.first).to be_a QTest::TestRun
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

    describe 'test suites' do
      it 'should move a test suite to another test cycle' do
        expect(@client).to receive(:move_test_suite)
          .with(project: 1,
                test_cycle: 2,
                test_suite: @test_suite.id,
                release: nil)
          .and_return({})

        expect(@client).to receive(:test_cycle)
          .with(project: 1, test_cycle: 2)
          .and_return({})

        expect(@test_suite.move_to(test_cycle: 2)).to eq @test_suite
        expect(@test_suite.test_cycle).to be_a QTest::TestCycle
      end

      it 'should move a test suite to another release' do
        expect(@client).to receive(:move_test_suite)
          .with(project: 1,
                release: 2,
                test_suite: @test_suite.id,
                test_cycle: nil)
          .and_return({})
        expect(@client).to receive(:release)
          .with(project: 1, release: 2)
          .and_return({})

        expect(@test_suite.move_to(release: 2)).to eq @test_suite
        expect(@test_suite.release).to be_a QTest::Release
      end
    end
  end
end

class StubClient < QTest::Client
end

module QTest
  describe TestCycle do
    before do
      @client = StubClient.new
    end

    describe 'test runs' do
      before do
        @project = QTest::Project.new(id: 1)
        @test_cycle = QTest::TestCycle.new(id: 4, project: @project)
        @test_run = QTest::TestRun.new(id: 3)
      end

      it 'should get all test runs' do
        expect(@client).to receive(:test_runs)
                           .with(project: 1, test_cycle: 4)
                           .and_return([@test_run])

        test_runs = @test_cycle.test_runs

        expect(test_runs).to be_a Array
        expect(test_runs.first).to eq @test_run
        expect(test_runs.first.test_cycle).to eq @test_cycle
        expect(test_runs.first.project).to eq @project
      end

      it 'should get a specific test run' do
        expect(@client).to receive(:test_run)
                           .with(project: 1, test_cycle: 4, id: 3)
                           .and_return(@test_run)

        test_run = @test_cycle.test_run(id: 3)

        expect(test_run).to eq @test_run
        expect(test_run.test_cycle).to eq @test_cycle
        expect(test_run.project).to eq @project
      end
    end
  end
end

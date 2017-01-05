class StubClient < QTest::Client
end

module QTest
  describe TestCycle do
    before do
      @client = StubClient.new
      @project = QTest::Project.new(id: 1)
      @test_cycle = QTest::TestCycle.new(id: 4, project: @project)
    end

    describe 'test suites' do
      before do
        @test_suite = QTest::TestSuite.new(id: 8)
      end

      it 'should get all test suites' do
        expect(@client).to receive(:test_suites)
                           .with(project: 1, test_cycle: 4)
                           .and_return([@test_suite])

        test_suites = @test_cycle.test_suites

        expect(test_suites).to be_a Array
        expect(test_suites.first).to eq @test_suite
        expect(test_suites.first.test_cycle).to eq @test_cycle
      end

      it 'should create a test suite' do
        expect(@client).to receive(:create_test_suite)
                           .with(project: 1, test_cycle: 4, name: 'Foo')
                           .and_return(@test_suite)

        test_suite = @test_cycle.create_test_suite(name: 'Foo')

        expect(test_suite).to eq @test_suite
        expect(test_suite.project).to eq @project
        expect(test_suite.test_cycle).to eq @test_cycle
      end
    end

    describe 'test runs' do
      before do
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
    end
  end
end

class StubClient < QTest::Client
end

module QTest
  describe TestCycle do
    before do
      @client = StubClient.new
      @project = QTest::Project.new(id: 1)
      @test_cycle = QTest::TestCycle.new(id: 4, project: @project)
    end

    describe 'test cycles' do
      it 'should get all test cycles' do
        expect(@client).to receive(:test_cycles)
          .with(project: 1, test_cycle: 4)
          .and_return([{}])

        test_cycles = @test_cycle.test_cycles

        expect(test_cycles).to be_a Array
        expect(test_cycles.first).to be_a QTest::TestCycle
        expect(test_cycles.first.project).to eq @project
        expect(test_cycles.first.test_cycle).to eq @test_cycle
      end

      it 'should return an empty array if no test cycles' do
        expect(@client).to receive(:test_cycles)
          .with(project: 1, test_cycle: 4)
          .and_return([])

        expect(@test_cycle.test_cycles).to eq []
      end

      it 'should create a test cycle' do
        expect(@client).to receive(:create_test_cycle)
          .with(project: 1,
                test_cycle: 4,
                attributes: {
                  name: 'Foo'
                })
          .and_return({})

        test_cycle = @test_cycle.create_test_cycle(name: 'Foo')

        expect(test_cycle).to be_a QTest::TestCycle
        expect(test_cycle.project).to eq @project
        expect(test_cycle.test_cycle).to eq @test_cycle
      end
    end

    describe 'test suites' do
      it 'should get all test suites' do
        expect(@client).to receive(:test_suites)
          .with(project: 1, test_cycle: 4)
          .and_return([{}])

        test_suites = @test_cycle.test_suites

        expect(test_suites).to be_a Array
        expect(test_suites.first).to be_a QTest::TestSuite
        expect(test_suites.first.project).to eq @project
        expect(test_suites.first.test_cycle).to eq @test_cycle
      end

      it 'should return an empty array if no test suites' do
        expect(@client).to receive(:test_suites)
          .with(project: 1, test_cycle: 4)
          .and_return([])

        expect(@test_cycle.test_suites).to eq []
      end

      it 'should create a test suite' do
        expect(@client).to receive(:create_test_suite)
          .with(project: 1,
                test_cycle: 4,
                attributes: {
                  name: 'Foo'
                })
          .and_return({})

        test_suite = @test_cycle.create_test_suite(name: 'Foo')

        expect(test_suite).to be_a QTest::TestSuite
        expect(test_suite.project).to eq @project
        expect(test_suite.test_cycle).to eq @test_cycle
      end
    end

    describe 'test runs' do
      it 'should get all test runs' do
        expect(@client).to receive(:test_runs)
          .with(project: 1, test_cycle: 4)
          .and_return([{}])

        test_runs = @test_cycle.test_runs

        expect(test_runs).to be_a Array
        expect(test_runs.first).to be_a QTest::TestRun
        expect(test_runs.first.test_cycle).to eq @test_cycle
        expect(test_runs.first.project).to eq @project
      end

      it 'should create a test run' do
        expect(@client).to receive(:create_test_run)
          .with(
            project: 1,
            test_cycle: 4,
            attributes: {
              name: 'TR001',
              test_case: {
                id: 6,
                test_case_version_id: 12345
              }
            }
          )
          .and_return({})

        test_run = @test_cycle.create_test_run(name: 'TR001',
                                               test_case: {
                                                 id: 6,
                                                 test_case_version_id: 12345
                                               })

        expect(test_run).to be_a QTest::TestRun
        expect(test_run.project).to eq @project
        expect(test_run.test_cycle).to eq @test_cycle
      end
    end
  end
end

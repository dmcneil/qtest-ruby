class StubClient < QTest::Client
end

module QTest
  describe Release do
    before do
      @client = StubClient.new
      @project = QTest::Project.new(id: 1)
      @release = QTest::Release.new(id: 5, project: @project)
    end

    describe 'test cycles' do
      before do
        @test_cycle = QTest::TestCycle.new(id: 6)
      end

      it 'should get all test cycles' do
        expect(@client).to receive(:test_cycles)
          .with(project: 1, release: 5)
          .and_return([{}])

        test_cycles = @release.test_cycles

        expect(test_cycles).to be_a Array
        expect(test_cycles.first).to be_a QTest::TestCycle
        expect(test_cycles.first.release).to eq @release
        expect(test_cycles.first.project).to eq @project
      end

      it 'should create a test cycle' do
        expect(@client).to receive(:create_test_cycle)
          .with({
            project: 1,
            release: 5,
            attributes: {
              name: 'A test cycle',
              description: 'A description'
            }
          })
          .and_return({})

        test_cycle = @release.create_test_cycle({
          name: 'A test cycle',
          description: 'A description'
        })

        expect(test_cycle).to be_a QTest::TestCycle
        expect(test_cycle.release).to eq @release
        expect(test_cycle.project).to eq @project
      end
    end

    describe 'test suites' do
      before do
        @test_suite = QTest::TestSuite.new(id: 3)
      end

      it 'should get all test suites' do
        expect(@client).to receive(:test_suites)
          .with(project: 1, release: 5)
          .and_return([{}])

        test_suites = @release.test_suites

        expect(test_suites).to be_a Array
        expect(test_suites.first).to be_a QTest::TestSuite
        expect(test_suites.first.release).to eq @release
        expect(test_suites.first.project).to eq @project
      end

      it 'should create a test suite' do
        expect(@client).to receive(:create_test_suite)
          .with({
            project: 1,
            release: 5,
            attributes: {
              name: 'A test suite',
              properties: [
                {
                  field_id: 1,
                  field_value: 'Field one',
                },
                {
                  field_id: 2,
                  field_value: 'Field two'
                }
              ],
              target_build_id: nil
            }
          })
          .and_return({})

        test_suite = @release.create_test_suite({
          name: 'A test suite',
          properties: [
            {
              field_id: 1,
              field_value: 'Field one'
            },
            {
              field_id: 2,
              field_value: 'Field two'
            }
          ]
        })

        expect(test_suite).to be_a QTest::TestSuite
        expect(test_suite.release).to eq @release
        expect(test_suite.project).to eq @project
      end
    end
  end
end

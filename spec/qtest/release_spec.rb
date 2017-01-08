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
          .and_return([@test_cycle])

        test_cycles = @release.test_cycles

        expect(test_cycles).to be_a Array
        expect(test_cycles.first).to eq @test_cycle
        expect(test_cycles.first.release).to eq @release
        expect(test_cycles.first.project).to eq @project
      end
    end

    describe 'test suites' do
      before do
        @test_suite = QTest::TestSuite.new(id: 3)
      end

      it 'should get all test suites' do
        expect(@client).to receive(:test_suites)
          .with(project: 1, release: 5)
          .and_return([@test_suite])

        test_suites = @release.test_suites

        expect(test_suites).to be_a Array
        expect(test_suites.first).to eq @test_suite
        expect(test_suites.first.release).to eq @release
        expect(test_suites.first.project).to eq @project
      end

      it 'should create a test suite' do
        expect(@client).to receive(:create_test_suite)
          .with({
            project: 1,
            release: 5,
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
          .and_return(@test_suite)

        test_suite = @release.create_test_suite({
          project: 1,
          release: 5,
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

        expect(test_suite).to eq @test_suite
        expect(test_suite.release).to eq @release
        expect(test_suite.project).to eq @project
      end
    end
  end
end

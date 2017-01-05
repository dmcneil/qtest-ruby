class StubClient < QTest::Client
end

module QTest
  describe Release do
    before do
      @client = StubClient.new
    end

    describe 'test cycles' do
      before do
        @project = QTest::Project.new(id: 1)
        @release = QTest::Release.new(id: 5, project: @project)
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

      it 'should get a specific test cycle' do
        expect(@client).to receive(:test_cycle)
                           .with(project: 1, release: 5, id: 6)
                           .and_return(@test_cycle)

        test_cycle = @release.test_cycle(id: 6)

        expect(test_cycle).to eq @test_cycle
        expect(test_cycle.release).to eq @release
        expect(test_cycle.project).to eq @project
      end
    end
  end
end

module QTest
  describe TestRun do
    before do
      @client = QTest::Client.new
      @project = QTest::Project.new(id: 1)
      @test_run = QTest::TestRun.new(id: 2, project: @project)
    end

    describe 'test cases' do
      it 'should get all test cases' do
        expect(@client).to receive(:test_cases)
          .with(project: 1, test_run: 2)
          .and_return([{}])

        test_cases = @test_run.test_cases

        expect(test_cases).to be_a Array
        expect(test_cases.first).to be_a QTest::TestCase
        expect(test_cases.first.project).to eq @project
        expect(test_cases.first.test_run).to eq @test_run
      end
    end
  end
end

module QTest
  describe TestCase do
    before do
      @client = QTest::Client.new
      @project = QTest::Project.new(id: 1)
      @test_case = QTest::TestCase.new(id: 2, project: @project)
    end

    it 'should get a test step by id' do
      expect(@client).to receive(:test_step)
        .with(project: 1, test_case: 2, id: 3)
        .and_return({})

      test_step = @test_case.step(id: 3)

      expect(test_step).to be_a QTest::TestStep
      expect(test_step.project).to eq @project
      expect(test_step.test_case).to eq @test_case
    end

    it 'should get all test steps' do
      expect(@client).to receive(:test_steps)
        .with(project: 1, test_case: 2)
        .and_return([{}])

      test_steps = @test_case.steps

      expect(test_steps).to be_a Array
      expect(test_steps.first).to be_a QTest::TestStep
      expect(test_steps.first.project).to eq @project
      expect(test_steps.first.test_case).to eq @test_case
    end
  end
end

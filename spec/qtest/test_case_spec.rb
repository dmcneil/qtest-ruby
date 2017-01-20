module QTest
  describe TestCase do
    before do
      @client = QTest::Client.new
      @project = QTest::Project.new(id: 1)
      @test_case = QTest::TestCase.new(id: 2, project: @project)
    end

    describe 'attributes' do
      it 'should have an id' do
        test_case = QTest::TestCase.new(id: 1)
        expect(test_case.id).to eq 1
      end

      it 'should have a name' do
        test_case = QTest::TestCase.new(name: 'Foo')
        expect(test_case.name).to eq 'Foo'
      end

      it 'should have a tag' do
        test_case = QTest::TestCase.new(tag: 'TC-FOO')
        expect(test_case.tag).to eq 'TC-FOO'
      end

      it 'should accept the :pid option for a tag' do
        test_case = QTest::TestCase.new(pid: 'TC-FOO')
        expect(test_case.tag).to eq 'TC-FOO'
      end
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

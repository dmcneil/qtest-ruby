module QTest
  describe TestCase do
    before do
      @client = QTest::Client.new
      @project = QTest::Project.new(id: 1)
      @test_case = QTest::TestCase.new(id: 2, project: @project)
    end

    describe 'attributes' do
      it 'has an id' do
        test_case = QTest::TestCase.new(id: 1)
        expect(test_case.id).to eq(1)
      end

      it 'has a name' do
        test_case = QTest::TestCase.new(name: 'Foo')
        expect(test_case.name).to eq('Foo')
      end

      it 'has a description' do
        test_case = QTest::TestCase.new(description: 'Foo')
        expect(test_case.description).to eq('Foo')
      end

      it 'has a precondition' do
        test_case = QTest::TestCase.new(precondition: 'Foo')
        expect(test_case.precondition).to eq('Foo')
      end

      it 'has an order' do
        test_case = QTest::TestCase.new(order: 1)
        expect(test_case.order).to eq(1)
      end

      it 'has a pid' do
        test_case = QTest::TestCase.new(pid: 'TC-FOO')
        expect(test_case.pid).to eq('TC-FOO')
      end

      it 'aliases tag for pid' do
        test_case = QTest::TestCase.new(pid: 'TC-FOO')
        expect(test_case.tag).to eq('TC-FOO')
      end

      it 'has a web_url' do
        test_case = QTest::TestCase.new(web_url: 'http://www.foo.com')
        expect(test_case.web_url).to eq('http://www.foo.com')
      end

      it 'aliases url for web_url' do
        test_case = QTest::TestCase.new(web_url: 'http://www.foo.com')
        expect(test_case.url).to eq('http://www.foo.com')
      end

      it 'has a test_case_version_id' do
        test_case = QTest::TestCase.new(test_case_version_id: 3)
        expect(test_case.test_case_version_id).to eq(3)
      end

      it 'aliases version for test_case_version_id' do
        test_case = QTest::TestCase.new(test_case_version_id: 3)
        expect(test_case.version).to eq(3)
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

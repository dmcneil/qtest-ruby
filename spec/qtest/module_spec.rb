module QTest
  describe Module do
    before do
      @client = QTest::Client.new
      @project = QTest::Project.new(id: 1)
      @project_module = QTest::Module.new(id: 2, project: @project)
    end

    it 'should get a child project module by id' do
      expect(@client).to receive(:module)
        .with(project: 1, module: 2, id: 3)
        .and_return({})

      project_module = @project_module.child_module(id: 3)

      expect(project_module).to be_a QTest::Module
      expect(project_module.project).to eq @project
      expect(project_module.module).to eq @project_module
    end

    it 'should get all child project modules' do
      expect(@client).to receive(:modules)
        .with(project: 1, module: 2, search: nil)
        .and_return([{}])

      project_modules = @project_module.child_modules

      expect(project_modules).to be_a Array
      expect(project_modules.first).to be_a QTest::Module
      expect(project_modules.first.project).to eq @project
      expect(project_modules.first.module).to eq @project_module
    end

    it 'should search for child modules' do
      expect(@client).to receive(:modules)
        .with(project: 1, module: 2, search: 'foo')
        .and_return([{}])

     project_modules = @project_module.child_modules(search: 'foo')

     expect(project_modules).to be_a Array
     expect(project_modules.first).to be_a QTest::Module
     expect(project_modules.first.project).to eq @project
     expect(project_modules.first.module).to eq @project_module
    end

    it 'should get all test cases' do
      expect(@client).to receive(:test_cases)
        .with(project: 1, module: 2)
        .and_return([{}])

      test_cases = @project_module.test_cases

      expect(test_cases).to be_a Array
      expect(test_cases.first).to be_a QTest::TestCase
      expect(test_cases.first.project).to eq @project
      expect(test_cases.first.module).to eq @project_module
    end
  end
end

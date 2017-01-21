class StubClient < QTest::Client
end

module QTest
  describe Project do
    before do
      @client = StubClient.new
    end

    describe 'class methods' do
      it 'should find by id' do
        expect(@client).to receive(:project)
          .with(id: 1)
          .and_return({})

        project = QTest::Project.find_by(id: 1)

        expect(project).to be_a QTest::Project
      end
    end

    describe 'releases' do
      before do
        @project = QTest::Project.new(id: 1)
      end

      it 'should get all releases' do
        expect(@client).to receive(:releases)
          .with(project: 1)
          .and_return([{}])

        releases = @project.releases

        expect(releases).to be_a Array
        expect(releases.first).to be_a QTest::Release
        expect(releases.first.project).to eq @project
      end

      it 'should get a specific release' do
        expect(@client).to receive(:release)
          .with(id: 5, project: 1)
          .and_return({})

        release = @project.release(id: 5)

        expect(release).to be_a QTest::Release
        expect(release.project).to eq @project
      end
    end

    describe 'modules' do
      before do
        @project = QTest::Project.new(id: 1)
      end

      it 'should get all modules' do
        expect(@client).to receive(:modules)
          .with(project: 1)
          .and_return([{}])

        modules = @project.modules

        expect(modules).to be_a Array
        expect(modules.first).to be_a QTest::Module
        expect(modules.first.project).to eq @project
      end

      it 'should get a specific module' do
        expect(@client).to receive(:module)
          .with(project: 1, id: 5)
          .and_return({})

        _module = @project.module(id: 5)

        expect(_module).to be_a QTest::Module
        expect(_module.project).to eq @project
      end
    end
  end
end

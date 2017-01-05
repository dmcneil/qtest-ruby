class StubClient < QTest::Client
end

module QTest
  describe Project do
    before do
      @client = StubClient.new
    end

    describe 'class methods' do
      it 'should find by id' do
        expect(@client).to receive(:project).with(1)
        QTest::Project.find_by(id: 1)
      end
    end

    describe 'releases' do
      before do
        @project = QTest::Project.new(id: 1)
        @release = QTest::Release.new(id: 5)
      end

      it 'should get all releases' do
        expect(@client).to receive(:releases)
                           .with(project: 1)
                           .and_return([@release])

        releases = @project.releases

        expect(releases).to be_a Array
        expect(releases.first).to eq @release
        expect(releases.first.project).to eq @project
      end

      it 'should get a specific release' do
        expect(@client).to receive(:release)
                           .with(id: 5, project: 1)
                           .and_return(@release)

        release = @project.release(id: 5)

        expect(release).to eq @release
        expect(release.project).to eq @project
      end
    end
  end
end

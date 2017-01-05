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
      end

      it 'should get all releases' do
        expect(@client).to receive(:releases).with(project: 1)
        @project.releases
      end

      it 'should get a specific release' do
        expect(@client).to receive(:release).with(id: 5, project: 1)
        @project.release(id: 5)
      end
    end
  end
end

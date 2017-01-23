class StubClient < QTest::Client
end

module QTest
  describe Release do
    before do
      @client = StubClient.new
      @project = QTest::Project.new(id: 1)
      @release = QTest::Release.new(id: 5, project: @project)
    end

    describe 'attributes' do
      it 'has an id' do
        expect(QTest::Release.new(id: 1).id).to eq(1)
      end

      it 'has a name' do
        expect(QTest::Release.new(name: 'Foo').name).to eq('Foo')
      end

      it 'has an order' do
        expect(QTest::Release.new(order: 3).order).to eq(3)
      end

      it 'has a pid' do
        expect(QTest::Release.new(pid: 'RL-1').pid).to eq('RL-1')
      end

      it 'aliases tag for pid' do
        expect(QTest::Release.new(pid: 'RL-1').tag).to eq('RL-1')
      end

      it 'has properties' do
        expect(QTest::Release.new(properties: []).properties).to eq([])
      end

      it 'has a web_url' do
        release = QTest::Release.new(web_url: 'http://www.foo.com')
        expect(release.web_url).to eq('http://www.foo.com')
      end

      it 'aliases url for web_url' do
        release = QTest::Release.new(web_url: 'http://www.foo.com')
        expect(release.url).to eq('http://www.foo.com')
      end

      it 'has a start date as a Time' do
        now_to_s = Time.now.to_s
        release = QTest::Release.new(start_date: now_to_s)
        expect(release.start_date).to be_a(Time)
      end

      it 'has an end date' do
        now_to_s = Time.now.to_s
        release = QTest::Release.new(end_date: now_to_s)
        expect(release.end_date).to be_a(Time)
      end
    end

    describe 'test cycles' do
      before do
        @test_cycle = QTest::TestCycle.new(id: 6)
      end

      it 'should get all test cycles' do
        expect(@client).to receive(:test_cycles)
          .with(project: 1, release: 5)
          .and_return([{}])

        test_cycles = @release.test_cycles

        expect(test_cycles).to be_a Array
        expect(test_cycles.first).to be_a QTest::TestCycle
        expect(test_cycles.first.release).to eq @release
        expect(test_cycles.first.project).to eq @project
      end

      it 'should create a test cycle' do
        expect(@client).to receive(:create_test_cycle)
          .with(project: 1,
                release: 5,
                attributes: {
                  name: 'A test cycle',
                  description: 'A description'
                })
          .and_return({})

        test_cycle = @release.create_test_cycle(name: 'A test cycle',
                                                description: 'A description')

        expect(test_cycle).to be_a QTest::TestCycle
        expect(test_cycle.release).to eq @release
        expect(test_cycle.project).to eq @project
      end
    end

    describe 'test suites' do
      before do
        @test_suite = QTest::TestSuite.new(id: 3)
      end

      it 'should get all test suites' do
        expect(@client).to receive(:test_suites)
          .with(project: 1, release: 5)
          .and_return([{}])

        test_suites = @release.test_suites

        expect(test_suites).to be_a Array
        expect(test_suites.first).to be_a QTest::TestSuite
        expect(test_suites.first.release).to eq @release
        expect(test_suites.first.project).to eq @project
      end

      it 'should create a test suite' do
        expect(@client).to receive(:create_test_suite)
          .with(project: 1,
                release: 5,
                attributes: {
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
          .and_return({})

        test_suite = @release.create_test_suite(name: 'A test suite',
                                                properties: [
                                                  {
                                                    field_id: 1,
                                                    field_value: 'Field one'
                                                  },
                                                  {
                                                    field_id: 2,
                                                    field_value: 'Field two'
                                                  }
                                                ])

        expect(test_suite).to be_a QTest::TestSuite
        expect(test_suite.release).to eq @release
        expect(test_suite.project).to eq @project
      end
    end
  end
end

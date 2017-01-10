module QTest
  module REST
    describe QueryBuilder do
      before do
        @qb = QTest::REST::QueryBuilder.new
      end

      it 'should return itself' do
        expect(@qb.project(1)).to eq @qb
      end

      it 'should append using with' do
        @qb.with('foo', '5')
        expect(@qb.build[:path]).to eq('/api/v3/foo/5')
      end

      it 'should ignore the api base url with an option' do
        expect(@qb.build(api_path: false)[:path]).to eq('')
      end

      it 'should append parent query params' do
        @qb.under(:foo, 1)

        expect(@qb.build[:query]).to eq({
          'parentType' => 'foo',
          'parentId' => 1
        })
      end

      describe 'project' do
        it 'should append /projects/:id' do
          @qb.project(1)

          expect(@qb.build[:path]).to eq('/api/v3/projects/1')
        end

        it 'should append /projects' do
          @qb.projects

          expect(@qb.build[:path]).to eq('/api/v3/projects')
        end
      end

      describe 'test case' do
        before do
          @qb.project(1)
        end

        it 'should append /test-cases/:id' do
          @qb.test_case(1)

          expect(@qb.build[:path]).to eq('/api/v3/projects/1/test-cases/1')
        end

        it 'should append /test-cases' do
          @qb.test_cases

          expect(@qb.build[:path]).to eq('/api/v3/projects/1/test-cases')
        end

        describe 'test steps' do
          before do
            @qb.test_case(1)
          end

          it 'should append /test-steps/:id' do
            @qb.test_step(1)

            expect(@qb.build[:path]).to eq('/api/v3/projects/1/test-cases/1/test-steps/1')
          end
        end
      end

      describe 'test cycle' do
        before do
          @qb.project(1)
        end

        it 'should append /test-cycles/:id' do
          @qb.test_cycle(1)

          expect(@qb.build[:path]).to eq('/api/v3/projects/1/test-cycles/1')
        end

        it 'should append /test-cycles' do
          @qb.test_cycles

          expect(@qb.build[:path]).to eq('/api/v3/projects/1/test-cycles')
        end
      end

      describe 'test suite' do
        before do
          @qb.project(1)
        end

        it 'should append /test-suites/:id' do
          @qb.test_suite(1)

          expect(@qb.build[:path]).to eq('/api/v3/projects/1/test-suites/1')
        end

        it 'should append /test-suites' do
          @qb.test_suites

          expect(@qb.build[:path]).to eq('/api/v3/projects/1/test-suites')
        end
      end

      describe 'test run' do
        before do
          @qb.project(1)
        end

        it 'should append /test-runs/:id' do
          @qb.test_run(1)

          expect(@qb.build[:path]).to eq('/api/v3/projects/1/test-runs/1')
        end

        it 'should append /test-runs' do
          @qb.test_runs

          expect(@qb.build[:path]).to eq('/api/v3/projects/1/test-runs')
        end
      end

      describe 'release' do
        before do
          @qb.project(1)
        end

        it 'should append /releases/:id' do
          @qb.release(1)

          expect(@qb.build[:path]).to eq('/api/v3/projects/1/releases/1')
        end

        it 'should append /releases' do
          @qb.releases

          expect(@qb.build[:path]).to eq('/api/v3/projects/1/releases')
        end
      end
    end
  end
end

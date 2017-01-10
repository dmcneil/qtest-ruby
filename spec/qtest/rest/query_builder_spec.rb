module QTest
  module REST
    describe QueryBuilder do
      before do
        @qb = QTest::REST::QueryBuilder.new
      end

      it 'should append using with' do
        @qb.with('foo', '5')
        expect(@qb.build[:path]).to eq('/api/v3/foo/5')
      end

      it 'should ignore the api base url with an option' do
        expect(@qb.build(:without_api_path)[:path]).to eq('')
      end

      describe 'build' do
        it 'should have a path' do
          expect(@qb.build).to have_key(:path)
        end

        it 'should have a query' do
          expect(@qb.build).to have_key(:query)
        end

        it 'should have headers' do
          expect(@qb.build).to have_key(:headers)
        end

        it 'should have a body' do
          expect(@qb.build).to have_key(:body)
        end

        describe 'options' do
          describe 'json' do
            it 'should convert the body to a json string' do
              query = @qb.data(foo: 'bar').build(:json)

              expect(query[:body]).to eq('{"foo":"bar"}')
            end

            it 'should add the Content-Type header' do
              expect(@qb.build(:json)[:headers]).to eq({
                'Content-Type' => 'application/json'
              })
            end
          end
        end
      end

      describe 'method chaining' do
        it 'should chain #with' do
          expect(@qb.with().with()).to eq(@qb)
        end

        it 'should chain #under' do
          expect(@qb.under(:foo, 'bar').under(:foo, 'baz')).to eq(@qb)
        end

        it 'should chain #header' do
          expect(@qb.header('foo', 'bar').header('foo', 'baz')).to eq(@qb)
        end

        it 'should chain #data' do
          expect(@qb.data().data()).to eq(@qb)
        end

        it 'should chain #param' do
          expect(@qb.param('foo', 'bar').param('foo', 'bar')).to eq(@qb)
        end
      end

      describe 'query params' do
        it 'should append parent query params' do
          @qb.under(:foo, 1)

          expect(@qb.build[:query]).to eq({
            'parentType' => 'foo',
            'parentId' => 1
          })
        end

        it 'should append query params' do
          @qb.param(:foo, 1)

          expect(@qb.build[:query]).to eq({
            'foo' => 1
          })
        end
      end

      describe 'headers' do
        it 'should add symbol headers' do
          @qb.header(:content_type, 'application/json')

          expect(@qb.build[:headers]).to eq({
            'Content-Type' => 'application/json'
          })
        end

        it 'should add string headers' do
          @qb.header('Content-Type', 'application/json')

          expect(@qb.build[:headers]).to eq({
            'Content-Type' => 'application/json'
          })
        end
      end

      describe 'data' do
        it 'should add data for the body' do
          @qb.data(foo: 'bar')

          expect(@qb.build[:body]).to eq({
            foo: 'bar'
          })
        end

        it 'should be aliased to body' do
          @qb.body(foo: 'bar')

          expect(@qb.build[:body]).to eq({
            foo: 'bar'
          })
        end
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

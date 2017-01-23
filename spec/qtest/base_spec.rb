module Z; end

class Z::Foo < QTest::Base
  attr_accessor :id, :project

  def initialize(_opts = {})
    @id = 1
    @project = 'project'
  end

  def bars(_opts = {})
    all(Z::Bar, foo: @id,
                project: @project)
  end

  def bar(_opts = {})
    unique(Z::Bar, foo: @id,
                   project: @project)
  end

  def create_bar(opts = {})
    create(Z::Bar, foo: @id, project: @project, attributes: opts)
  end
end

class Z::Bar
  attr_accessor :foo, :project

  def initialize(opts = {})
    @id = opts[:id]
    @foo = opts[:foo]
    @project = opts[:project]
  end
end

class StubClient < QTest::Client
  def foos(_opts = {})
    [{}]
  end

  def bars(_opts = {})
    [{}]
  end

  def bar(_opts = {})
    {}
  end

  def create_bar(_opts = {})
    {}
  end
end

module QTest
  describe Base do
    before do
      @client = StubClient.new
      @foo = Z::Foo.new
    end

    describe 'find by' do
      it 'can find an object by id' do
        expect(@client).to receive(:unique)
          .with(Z::Foo, id: 1)
          .and_return({id: 1})

        foo = Z::Foo.find_by(id: 1)

        expect(foo).to be_a(Z::Foo)
        expect(foo.id).to eq(@foo.id)
      end

      it 'can find by any property' do
        expect(@client).to receive(:all)
          .with(Z::Foo, project: 'project')
          .and_return([{id: 1, project: 'project'}])

        foo = Z::Foo.find_by(project: 'project')

        expect(foo).to be_a(Z::Foo)
        expect(foo.id).to eq(@foo.id)
        expect(foo.project).to eq(@foo.project)
      end
    end

    it 'should be able to get all resources of a type' do
      expect(@client).to receive(:all)
        .with(Z::Bar, foo: @foo.id, project: 'project')
        .and_return([{}])

      bars = @foo.bars

      expect(bars).to be_a Array
      expect(bars.first).to be_a Z::Bar
      expect(bars.first.foo).to eq @foo
      expect(bars.first.project).to eq @foo.project
    end

    it 'should get a single, unique type' do
      expect(@client).to receive(:unique)
        .with(Z::Bar, foo: @foo.id, project: 'project')
        .and_return({})

      bar = @foo.bar

      expect(bar).to be_a Z::Bar
      expect(bar.foo).to eq @foo
      expect(bar.project).to eq @foo.project
    end

    it 'should create a new type' do
      expect(@client).to receive(:create)
        .with(
          Z::Bar,
          foo: @foo.id,
          project: @foo.project,
          attributes: {
            name: 'foo',
            description: 'bar'
          }
        )
        .and_return({})

      bar = @foo.create_bar(name: 'foo', description: 'bar')

      expect(bar).to be_a Z::Bar
      expect(bar.foo).to eq @foo
      expect(bar.project).to eq @foo.project
    end
  end
end

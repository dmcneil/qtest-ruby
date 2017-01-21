module Z; end

class Z::Foo < QTest::Base
  attr_accessor :project

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
    create(Z::Bar, opts)
  end
end

class Z::Bar
  attr_accessor :foo, :project

  def initialize(opts = {})
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

    it 'should be able to get all resources of a type' do
      foos = @foo.bars

      expect(foos).to be_a Array
      expect(foos.first).to be_a Z::Bar
    end

    it 'should transfer the caller to the new type' do
      bars = @foo.bars

      expect(bars.first.foo).to eq @foo
    end

    it 'should transfer types in the opts to the new type' do
      bazs = @foo.bars(project: 'not_nil')

      expect(bazs.first.project).to eq 'project'
    end

    it 'should get a single, unique type' do
      bar = @foo.bar

      expect(bar).to be_a Z::Bar
    end

    it 'should create a new type' do
      bar = @foo.create_bar(name: 'foo', description: 'bar')

      expect(bar).to be_a Z::Bar
      expect(bar.foo).to eq @foo
    end
  end
end

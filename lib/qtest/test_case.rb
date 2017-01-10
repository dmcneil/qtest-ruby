module QTest
  class TestCase
    BASE_PATH = '/test-cases'

    attr_accessor :id

    def initialize(opts = {})
      @id = opts[:id]
    end
  end
end

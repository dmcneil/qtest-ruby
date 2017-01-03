module QTest
  class Release
    attr_accessor :id

    def initialize(opts={})
      @id = opts[:id]
    end
  end
end

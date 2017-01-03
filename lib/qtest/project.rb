module QTest
  class Project
    attr_accessor :id

    def initialize(opts={})
      @id = opts[:id]
    end
  end
end

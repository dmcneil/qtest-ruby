module QTest
  class TestCycle < QTest::Base
    attr_accessor :id, :project, :release

    def initialize(opts={})
    end
  end
end

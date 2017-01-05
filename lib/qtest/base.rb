module QTest
  class Base
    class << self
      def method_missing(name, *args, &block)
        if name == :client
          raise QTest::Error, 'No QTest::Client found. Create one using QTest::Client.new first.'
        else
          super
        end
      end
    end
  end
end

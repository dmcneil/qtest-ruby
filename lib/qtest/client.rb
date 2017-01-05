module QTest
  class Client
    include QTest::REST::API

    def initialize(opts={})
      define_base_client
    end

    # Configure the Client.
    #
    # ## Example
    #
    #     client = Client.new.configure do |c|
    #       c.base_uri = 'http//qtest.mycompany.com'
    #     end
    #
    def configure
      yield self
      self
    end

    def base_uri
      self.class.base_uri
    end

    def base_uri=(uri)
      self.class.send(:base_uri, uri)
      @base_uri = uri
    end

    private

    def define_base_client
      this = self
      QTest::Base.send(:define_singleton_method, :client) do
        this
      end
    end
  end
end

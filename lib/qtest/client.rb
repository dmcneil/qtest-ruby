module QTest
  class Client
    include QTest::REST::API

    def initialize(_opts = {})
      define_base_client
      define_base_instance_client
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

    # Get the base URI registered for the Client.
    #
    # @example
    #
    #     client = Client.new.configure do |c|
    #       c.base_uri = 'http://qtest.mycompany.com'
    #     end
    #
    #     client.base_uri #=> 'http://qtest.mycompany.com'
    #
    # @return [String]
    def base_uri
      self.class.base_uri
    end

    # Set the base URI for the Client.
    #
    # @param uri [String] host/address
    def base_uri=(uri)
      self.class.send(:base_uri, uri)
      @base_uri = uri
    end

    private

    # @api private
    def define_base_client
      this = self
      QTest::Base.send(:define_singleton_method, :client) do
        this
      end
    end

    # @api private
    def define_base_instance_client
      this = self
      QTest::Base.send(:define_method, :client) do
        this
      end
    end
  end
end

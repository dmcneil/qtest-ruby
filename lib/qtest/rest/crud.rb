module QTest
  module REST
    module CRUD
      def create(klass, args={})
        options = {
          query: args[:query],
          headers: {'Content-Type' => 'application/json'},
          body: args[:body]
        }

        response = handle_response(self.class.post(args[:path], options))
        deserialize_response(response, klass)
      end
    end
  end
end

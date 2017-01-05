module QTest
  module REST
    module CRUD
      def create(klass, args={})
        options = {
          query: args[:query],
          headers: {'Content-Type' => 'application/json'},
          body: args[:body].to_json
        }

        response = handle_response(self.class.post(args[:path], options))
        deserialize_response(response, klass)
      end

      def read(klass, args={})
        options = {
          query: args[:query]
        }

        response = handle_response(self.class.get(args[:path], options))
        deserialize_response(response, klass)
      end

      def update(klass, args={})
        options = {
          headers: {'Content-Type' => 'application/json'},
          body: args[:body].to_json
        }

        options[:query] = args[:query] if args[:query]

        response = handle_response(self.class.put(args[:path], options))
        deserialize_response(response, klass)
      end

      def delete(args={})
        options = {
          query: args[:query]
        }

        handle_response(self.class.delete(args[:path], options), raw: true)
      end
    end
  end
end

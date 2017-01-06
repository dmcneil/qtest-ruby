module QTest
  module REST
    module CRUD
      def post(klass, path, args = {})
        options = {
          query: args[:query],
          headers: { 'Content-Type' => 'application/json' },
          body: args[:body].to_json
        }

        response = handle_response(self.class.post(path, options))
        deserialize_response(response, klass)
      end

      def get(klass, path, args = {})
        response = handle_response(self.class.get(path, args))
        deserialize_response(response, klass)
      end

      def put(klass, path, args = {})
        options = {
          query: args[:query],
          headers: { 'Content-Type' => 'application/json' },
          body: args[:body].to_json
        }

        response = handle_response(self.class.put(path, options))
        deserialize_response(response, klass)
      end

      def delete(path, args = {})
        options = {
          query: args[:query]
        }

        handle_response(self.class.delete(path, options), raw: true)
      end
    end
  end
end

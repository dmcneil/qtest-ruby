module QTest
  module REST
    module Utils
      def post(query, opts = {})
        handle_response(self.class.post(query[:path], query), opts)
      end

      def get(query, opts = {})
        handle_response(self.class.get(query[:path], query), opts)
      end

      def put(query, opts = {})
        handle_response(self.class.put(query[:path], query), opts)
      end

      def delete(query, opts = {})
        handle_response(self.class.delete(query[:path], query), raw: true)
      end

      # Handle a Response based on its status code.
      #
      # By default, the Response body is assumed to be parsed
      # from JSON.
      #
      # ## Options
      #
      #     * :raw - Return the Response body without decoding.
      #
      # @param response [Net::HTTP::Response] response to handle
      # @param opts [Hash] Hash of options
      def handle_response(response, opts = {})
        case response.code
        when 200..207
          if opts[:raw]
            response.body
          else
            decode_response_body(response.body)
          end
        when 401
          raise QTest::AuthorizationError, response.body
        else
          raise QTest::Error, response.body
        end
      end

      # Decode a String (Response body, typically) from JSON.
      #
      # By default, keys in the Hash will be converted to symbols.
      #
      # @param body [String] String to decode
      # @param symbolize_keys [Boolean] convert keys to Symbols
      def decode_response_body(body, symbolize_keys = true)
        JSON.parse(body, symbolize_names: symbolize_keys)
      end
    end
  end
end

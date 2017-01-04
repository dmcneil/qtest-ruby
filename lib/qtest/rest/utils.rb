module QTest
  module REST
    module Utils
      # Build a path from the supplied args.
      #
      # ## Example
      #
      #     @id = 1
      #     build_path("/api/v3", :projects, @id)
      #     #=> "/api/v3/projects/1"
      #
      # @param args [Array] arguments to build with
      # @return [String]
      def build_path(*args)
        args = args.map { |arg| arg.to_s }.join('/')

        unless args.empty?
          unless args.start_with?('/')
            args = "/#{args}"
          end
        end

        args
      end

      # Convert JSON (Hash) to an Object or Objects.
      #
      # ## Example
      #
      #     json_to({id: 1}, Foo)
      #
      # @param json [Hash] json in Hash form
      # @param klass [Class] Class type to create
      def deserialize_response(json, klass)
        if json.is_a? Array
          json.map do |element|
            if klass == Hash
              element
            else
              klass.new(element)
            end
          end
        elsif json.is_a? Hash
          return json if klass == Hash
          klass.new(json)
        end
      end

      # Build a request query parameter.
      #
      # ## Example
      #
      #     build_parent_query_param(5, :release)
      #     #=> {'parentId' => 5, 'parentType' => 'release'}
      #
      # @param parent_id [Integer/String] id of the parent
      # @param parent_type [Symbol/String] type of the parent
      def build_parent_query_param(parent_id, parent_type)
        parent_type = parent_type.to_s.gsub('_', '-') if parent_type.is_a? Symbol

        {
          'parentId' => parent_id,
          'parentType' => parent_type
        }
      end

      def release_parent_query_param(release_id)
        build_parent_query_param(release_id, :release)
      end

      def test_cycle_parent_query_param(test_cycle_id)
        build_parent_query_param(test_cycle_id, :test_cycle)
      end

      def test_suite_parent_query_param(test_suite_id)
        build_parent_query_param(test_suite_id, :test_suite)
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
      def handle_response(response, opts={})
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
      def decode_response_body(body, symbolize_keys=true)
        JSON.parse(body, symbolize_names: symbolize_keys)
      end
    end
  end
end

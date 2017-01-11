require 'active_support/inflector'

module QTest
  module REST
    class QueryBuilder
      RESOURCES = [
        :project,
        :test_case,
        :release,
        :test_cycle,
        :test_suite,
        :test_run,
        :test_step
      ]

      def initialize(*opts)
        RESOURCES.each do |resource|
          define_resource(resource)
          define_resources(resource)
        end

        @options = opts

        @path = []
        @body = {}
        @query = {}
        @headers = {}
        @parent = {}
      end

      def options(*opts)
        opts.each do |opt|
          @options << opt unless @options.include?(opt)
        end

        self
      end

      def with(*paths)
        @path << paths
        self
      end

      def parent(value)
        key = value.keys[0]
        @parent = {
          'parentType' => key.to_s.dasherize,
          'parentId' => value[key]
        }

        self
      end
      alias_method :under, :parent

      def header(key, value)
        key = encode_for_header(key)
        @headers[key] = value

        self
      end

      def data(params = {})
        @body.merge!(params)

        self
      end
      alias_method :body, :data

      def param(key, value)
        @query[key.to_s] = value

        self
      end

      def determine_parent!(opts = {})
        if opts[:release]
          parent(release: opts[:release])
        elsif opts[:test_suite]
          parent(test_suite: opts[:test_suite])
        elsif opts[:test_cycle]
          parent(test_cycle: opts[:test_cycle])
        end

        self
      end

      def build
        unless @options.include?(:without_api_path)
          @path = [QTest::REST::API::BASE_PATH, @path].flatten
        end

        @query.merge!(@parent)

        sanitize_body!
        encode_body!

        {
          path: @path.join('/'),
          query: @query,
          headers: @headers,
          body: @body
        }
      end

      private

      def define_resource(resource)
        self.class.send(:define_method, resource) do |value|
          value = case value
                  when Integer
                    value.to_s
                  when String
                    value
                  else
                    value.id if value.respond_to?(:id)
                  end

          @path << encode_for_path(resource)
          @path << value

          self
        end
      end

      def define_resources(resource)
        self.class.send(:define_method, resource.to_s.pluralize) do
          @path << encode_for_path(resource)
          self
        end
      end

      def encode_for_path(resource)
        resource.to_s.pluralize.dasherize
      end

      def encode_for_header(key)
        key.to_s.titleize.gsub(/\s+/, '-')
      end

      def sanitize_body!
        @body.reject! { |_k, v| v.nil? }
      end

      def encode_body!
        if @options.include?(:json)
          header(:content_type, 'application/json')
          @body = @body.to_json if @options.include?(:json)
        end
      end
    end
  end
end

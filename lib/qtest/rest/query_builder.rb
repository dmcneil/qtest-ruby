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

      def initialize
        RESOURCES.each do |resource|
          define_resource(resource)
          define_resources(resource)
        end
        @path = []
        @query = {}
        @headers = {}
        @body = {}
      end

      def with(*paths)
        @path << paths
        self
      end

      def under(resource, id)
        param('parentType', resource.to_s.dasherize)
        param('parentId', id)
        self
      end
      alias_method :parent, :under

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

      def build(*opts)
        unless opts.include?(:without_api_path)
          @path = [QTest::REST::API::BASE_PATH, @path].flatten
        end

        if opts.include?(:json)
          header(:content_type, 'application/json')
          body = @body.to_json
        else
          body = @body
        end

        {
          path: @path.join('/'),
          query: @query,
          headers: @headers,
          body: body
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
    end
  end
end

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
      end

      def with(*paths)
        @path << paths
      end

      def under(resource, id)
        @query['parentType'] = resource.to_s
        @query['parentId'] = id
      end
      alias_method :parent, :under


      def build(opts = {})
        unless opts[:api_path] == false
          @path = [QTest::REST::API::BASE_PATH, @path].flatten
        end

        {
          path: @path.join('/'),
          query: @query
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
    end
  end
end

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
        :test_run
      ]

      def initialize
        RESOURCES.each { |resource| define_resource(resource) }
        @path = []
      end

      def build(opts = {})
        if opts[:base_path]
          @path << opts[:base_path]
        else
          @path << QTest::REST::API::BASE_PATH
        end

        [
          @project,
          @release,
          @test_case,
          @test_suite,
          @test_cycle,
          @test_run
        ].compact.each do |resource|
          @path << resource
        end

        {
          path: @path.join
        }
      end

      private

      def define_resource(resource)
        resource_pluralized = resource.to_s.pluralize
        resource_base_path = "/#{resource_pluralized.dasherize}"

        self.class.send(:define_method, resource) do |value|
          value = case value
                  when Integer
                    value.to_s
                  when String
                    value
                  else
                    value.id if value.respond_to?(:id)
                  end

          value.prepend("#{resource_base_path}/")
          self.instance_variable_set("@#{resource}", value)

          self
        end

        self.class.send(:define_method, resource_pluralized) do
          self.instance_variable_set("@#{resource}",
                                     resource_base_path)
          self
        end
      end
    end
  end
end

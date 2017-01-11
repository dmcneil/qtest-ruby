require 'active_support/inflector'

module QTest
  class Base
    class << self
      def method_missing(name, *args, &block)
        if name == :client
          raise QTest::Error, 'No QTest::Client found. Create one using QTest::Client.new first.'
        else
          super
        end
      end
    end

    def all(type, opts = {})
      type_formatted = type.to_s.demodulize.underscore.pluralize

      resources = client.send(type_formatted, opts)
      resources.map do |resource|
        resource = type.new(resource)
        transfer_relationships(resource, opts)

        resource
      end
    end

    private

    def transfer_relationships(resource, opts = {})
      self_iv = :"@#{self.class.to_s.demodulize.underscore}"
      if resource.instance_variable_defined?(self_iv)
        resource.instance_variable_set(self_iv, self)
      end

      opts.each_key do |key|
        key_iv = :"@#{key}"
        next if key_iv == self_iv
        if resource.instance_variable_defined?(key_iv)
          original = self.instance_variable_get(key_iv)
          resource.instance_variable_set(key_iv, original)
        end
      end
    end

    def symbolize(value)
      value.to_s.demodulize.underscore
    end
  end
end

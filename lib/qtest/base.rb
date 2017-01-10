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
      resources = client.send(to_plural(symbolize(type)), opts)
      resources.map do |resource|
        resource = to_class(type).new(resource)
        transfer_relationships(resource, opts)

        resource
      end
    end

    private

    def transfer_relationships(resource, opts = {})
      self_iv = :"@#{symbolize(self.class)}"
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
      value.to_s.demodulize.downcase.underscore.to_sym
    end

    def to_plural(resource)
      resource.to_s.pluralize
    end

    def to_class(resource)
      resource.to_s.classify.constantize
    end
  end
end

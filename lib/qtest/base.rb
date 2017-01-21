require 'active_support/inflector'

module QTest
  class Base
    class << self
      def method_missing(name, *args, &block)
        if name == :client
          raise QTest::Error,
                'No QTest::Client found. Create one using QTest::Client.new first.'
        else
          super
        end
      end
    end

    protected

    def all(type, opts = {})
      attributes = client.send(methodize(type).pluralize, opts)
      attributes.map do |attribute|
        to_type(type, attribute, opts)
      end
    end

    def unique(type, opts = {})
      attributes = client.send(methodize(type), opts)
      to_type(type, attributes, opts)
    end

    def create(type, opts = {})
      attributes = client.send("create_#{methodize(type)}", opts)
      to_type(type, attributes, opts)
    end

    def move(opts = {})
      attributes = client.send("move_#{methodize(self.class)}", opts)
      to_type(self.class, attributes, opts)
    end

    private

    def to_type(type, attributes, opts = {})
      resource = type.new(attributes)
      transfer_relationships(resource, opts)

      resource
    end

    def transfer_relationships(resource, opts = {})
      self_iv = :"@#{self.class.to_s.demodulize.underscore}"
      if resource.instance_variable_defined?(self_iv)
        resource.instance_variable_set(self_iv, self)
      end

      opts.each_key do |key|
        key_iv = :"@#{key}"
        next if key_iv == self_iv
        if resource.instance_variable_defined?(key_iv)
          original = instance_variable_get(key_iv)
          resource.instance_variable_set(key_iv, original)
        end
      end
    end

    def methodize(type, _opts = {})
      type.to_s.demodulize.underscore
    end
  end
end

require 'active_support/inflector'

module QTest
  class Base
    class << self
      def find_by(opts = {})
        return self.new(client.unique(self, opts)) if opts[:id]

        response = client.all(self, opts)
        return if response.empty?

        response.each do |object|
          opts.each do |opt_key, opt_value|
            return self.new(object) if object[opt_key] == opt_value
          end
        end

        if opts[:page]
          opts[:page] += 1
          find_by(opts)
        end
      end

      def method_missing(name, *args, &block)
        if name == :client
          raise QTest::Error,
                'No QTest::Client found. Create one using QTest::Client.new first.'
        else
          super
        end
      end
    end

    def initialize(opts = {})
      opts.each do |key, value|
        if self.respond_to?("#{key}=")
          self.send(:"#{key}=", value)
        end
      end
    end

    def all(type, opts = {})
      attributes = client.all(type, opts)
      attributes.map do |attribute|
        to_type(type, attribute, opts)
      end
    end

    def unique(type, opts = {})
      attributes = client.unique(type, opts)
      to_type(type, attributes, opts)
    end

    def create(type, opts = {})
      attributes = client.create(type, opts)
      to_type(type, attributes, opts)
    end

    def move(opts = {})
      attributes = client.move(self.class, opts)
      to_type(self.class, attributes, opts)
    end

    private

    # @api private
    def to_type(type, attributes, opts = {})
      resource = type.new(attributes)
      transfer_relationships(resource, opts)
    end

    # @api private
    def transfer_relationships(resource, opts = {})
      self_class = self.class.to_s.demodulize.underscore.to_sym

      if resource.respond_to?("#{self_class}=")
        resource.send("#{self_class}=", self)
      end

      opts.each_key do |key|
        next if key == self_class
        if resource.respond_to?("#{key}=")
          resource.send("#{key}=", self.send(key))
        end
      end

      resource
    end
  end
end

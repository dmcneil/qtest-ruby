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

      private

      def paginated_request(opts = {})
        response = client.all(self.class, opts)
        return if response.empty?

        parsed_object = parse_response_for_object(response)
        return parsed_object if parsed_object

        opts[:page] += 1
        paginated_request(opts)
      end
    end

    def initialize(opts = {})
      opts.each do |key, value|
        if self.respond_to?("#{key}=")
          self.send(:"#{key}=", value)
        end
      end
    end

    protected

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

    def to_type(type, attributes, opts = {})
      resource = type.new(attributes)
      transfer_relationships(resource, opts)
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

      resource
    end
  end
end

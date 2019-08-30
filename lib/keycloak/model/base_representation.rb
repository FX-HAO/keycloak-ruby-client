module Keycloak
  module Model
    class BaseRepresentation
      class << self
        def fields(*names)
          names.each do |name|
            field name
          end
        end

        def field(name, type = :any)
          define_reader name, type
          define_writer name, type
          snake_case_name = name.to_s.underscore
          if name.to_s != snake_case_name
            alias_method snake_case_name, name
            alias_method "#{snake_case_name}=", "#{name}="
          end

          name_sym = name.to_sym
          attributes << name_sym
          registry[name_sym] = type
        end

        def type_resolve(value, type)
          case
          when type == :any
            value
          when type == Integer
            value.to_i
          when type == String
            value.to_s
          when type == Float
            value.to_f
          when type.is_a?(Scalar::ArrayType)
            value.map { |e| type_resolve(e, type.type) }
          when type < BaseRepresentation
            value.is_a?(type) ? value : type.new(value)
          else
            type.new value
          end
        end

        def define_reader(name, type)
          attr_reader name
        end

        def define_writer(name, type)
          define_method "#{name}=" do |value|
            instance_variable_set("@#{name}", self.class.type_resolve(value, type))
          end
        end

        def attributes
          @attributes ||= Concurrent::Array.new
        end

        def registry
          @registry ||= Concurrent::Hash.new
        end
      end

      def initialize(payload = {})
        payload.each do |key, value|
          if self.class.attributes.include?(key.to_sym) || self.class.attributes.include?(key.to_s.camelize(:lower).to_sym)
            send("#{key}=", value)
          end
        end
      end

      def as_json(*options)
        h = {}
        self.class.attributes.each do |attr|
          v = instance_variable_get("@#{attr}")
          h[attr] = v unless v.nil?
        end
        h
      end

      def to_json
        as_json.to_json
      end
    end
  end
end

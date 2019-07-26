module Keycloak
  module Scalar
    class ArrayType
      attr_accessor :type

      def initialize(type)
        @type = type
      end
    end
  end
end

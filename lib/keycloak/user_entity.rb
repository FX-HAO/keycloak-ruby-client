module Keycloak
  module UserEntity
    extend ActiveSupport::Concern

    class_methods do
      cattr_reader :keycloak_client

      # @param client [Keycloak::Client] keycloak client
      def use_keycloak_client(client)
        @keycloak_client = client
      end

      def keycloak_identify
        id
      end
    end

    included do
      def user_info(reload = false)
        _set_or_get_keycloak_data(:user_info, reload) { keycloak_client.find_user(keycloak_identify) }
      end

      def realm_roles(reload = false)
        _set_or_get_keycloak_data(:realm_roles, reload) { keycloak_client.find_user_realm_roles(keycloak_identify) }
      end

      def has_role?(role)
        realm_roles.include?(role)
      end

      def _set_or_get_keycloak_data(attr_name, reload)
        reload ? instance_variable_set(yield) : instance_variable_get(attr_name) || instance_variable_set(yield)
      end
    end
  end
end

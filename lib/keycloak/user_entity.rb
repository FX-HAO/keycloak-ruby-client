module Keycloak
  module UserEntity
    extend ActiveSupport::Concern

    included do
      def keycloak_client
        raise NotImplementedError
      end

      def keycloak_identify
        id
      end

      def user_info(reload = false)
        _set_or_get_keycloak_data(:@user_info, reload) { keycloak_client.find_user(keycloak_identify) }
      end

      def realm_roles(reload = false)
        _set_or_get_keycloak_data(:@realm_roles, reload) { keycloak_client.find_user_realm_roles(keycloak_identify) }
      end

      def has_role?(role)
        realm_roles.map(&:name).include?(role)
      end

      def _set_or_get_keycloak_data(attr_name, reload)
        reload ?
          instance_variable_set(attr_name, yield) :
          instance_variable_get(attr_name) || instance_variable_set(attr_name, yield)
      end
    end
  end
end

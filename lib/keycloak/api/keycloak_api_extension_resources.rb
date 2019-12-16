# Keycloak API extension resource from https://github.com/FX-HAO/keycloak-api-extension
module Keycloak
  module API
    module KeycloakAPIExtensionResources
      extend ActiveSupport::Concern
      include Concerns::APIUtil

      def api_extension_resources_url
        realm_url + "/keycloak-api-extension/"
      end

      # @param user_id [String] user id
      # @return Boolean
      def if_otp_exists(user_id)
        url = api_extension_resources_url + "users/#{user_id}/if-otp-exists"
        JSON.parse(get(url))["status"]
      end

      # @param user_id [String] user id
      # @param otp [String] otp
      # @return Boolean
      def validate_otp(user_id, otp)
        url = api_extension_resources_url + "users/#{user_id}/validate-otp"
        JSON.parse(post(url, otp: otp))["status"]
      end
    end
  end
end

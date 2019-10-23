module Keycloak
  module API
    module ProtectionResources
      extend ActiveSupport::Concern
      include Concerns::APIUtil

      # use this when you are mainly interested in either the overall decision
      # or the permissions granted by the server, this is much expensive than
      # decoding JWT cuz this asks from keycloak server every time. Always use
      # JWT unless there is a compelling reason to use this.
      #
      # @param permissions [String] A string representing a set of one or more
      #   resources and scopes the client is seeking access. The format of the
      #   string must be: RESOURCE_ID#SCOPE_ID. For instance:
      #   Resource A#Scope A, Resource A#Scope A, Scope B, Scope C, Resource A,
      #   #Scope A. See https://www.keycloak.org/docs/latest/authorization_services/#_service_obtaining_permissions
      #   for more details.
      # @param access_token [Keycloak::AccessToken] access token
      # @return [Boolean] true if the permissions granted or false when forbidden
      def granted_by_server(permissions, access_token, extra_claims: {})
        url = admin_realm_url + "/protocol/openid-connect/token"
        params = {
          grant_type: "urn:ietf:params:oauth:grant-type:uma-ticket",
          audience: @realm,
          permission: permissions,
          response_mode: "decision"
        }
        if !extra_claims.empty?
          params[:claim_token] = Base64.strict_decode64(extra_claims.to_json)
          params[:claim_token_format] = "urn:ietf:params:oauth:token-type:jwt"
        end
        res = JSON.parse post(url, params,
          headers: {content_type: :json, authorization: access_token.authorization},
          try_refresh_token: false
        )
        res["result"]
      rescue RestClient::Forbidden, RestClient::Unauthorized
        false
      end
    end
  end
end

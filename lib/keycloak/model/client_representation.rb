module Keycloak
  module Model
    class ClientRepresentation < BaseRepresentation
      fields :id, :clientId, :name, :baseUrl, :surrogateAuthRequired, :enabled,
             :clientAuthenticatorType, :redirectUris, :webOrigins, :notBefore, :bearerOnly,
             :consentRequired, :standardFlowEnabled, :implicitFlowEnabled, :directAccessGrantsEnabled,
             :serviceAccountsEnabled, :publicClient, :frontchannelLogout, :protocol, :attributes,
             :authenticationFlowBindingOverrides, :fullScopeAllowed, :nodeReRegistrationTimeout,
             :protocolMappers, :defaultClientScopes, :optionalClientScopes, :access
    end
  end
end
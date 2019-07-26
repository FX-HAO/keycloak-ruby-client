module Keycloak
  module Model
    class UserRepresentation < BaseRepresentation
      fields :id, :createdTimestamp, :username, :enabled, :totp, :emailVerified,
             :disableableCredentialTypes, :requiredActions, :notBefore, :access,
             :attributes, :clientConsents, :clientRoles, :credentials, :email,
             :federatedIdentities, :federationLink, :firstName, :groups, :lastName,
             :origin, :realmRoles, :self, :serviceAccountClientId

      field :credentials, Scalar::ArrayType.new(CredentialRepresentation)
    end
  end
end

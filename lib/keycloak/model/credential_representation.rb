module Keycloak
  module Model
    class CredentialRepresentation < BaseRepresentation
      fields :algorithm, :config, :counter, :createdDate, :device, :digits,
             :hashIterations, :hashedSaltedValue, :period, :salt, :temporary,
             :type, :value
    end
  end
end

module Keycloak
  module Model
    class RealmRepresentation < BaseRepresentation
      fields :id, :realm, :enabled
    end
  end
end
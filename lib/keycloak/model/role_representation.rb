module Keycloak
  module Model
    class RoleRepresentation < BaseRepresentation
      fields :clientRole, :composite, :containerId, :description, :id, :name
    end
  end
end

module Keycloak
  module API
    module RoleResources
      extend ActiveSupport::Concern
      include Concerns::APIUtil

      # @param role_rep [Keycloak::Model::RoleRepresentation] role representation
      # @return [Keycloak::Model::RoleRepresentation] role representation
      def create_or_find_role(role_rep)
        create_role(role_rep) && find_role_by_name(role_rep.name)
      rescue RestClient::Conflict
        find_role_by_name(role_rep.name)
      end

      # @return [Keycloak::Model::RoleRepresentation] role representation
      def find_role_by_name(name)
        url = admin_realm_url + "/roles/#{name}"
        Model::RoleRepresentation.new JSON.parse(get(url).body)
      rescue RestClient::NotFound
        nil
      end

      # @param role_rep [Keycloak::Model::RoleRepresentation] role representation
      # @return [Keycloak::Model::RoleRepresentation] role representation
      def create_role(role_rep)
        url = admin_realm_url + "/roles"
        post(url, role_rep.to_json, headers: {content_type: :json})
      end
    end
  end
end

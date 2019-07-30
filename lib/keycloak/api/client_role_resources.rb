module Keycloak
  module API
    module ClientRoleResources
      extend ActiveSupport::Concern
      include Concerns::APIUtil

      # @param id [String] id of client (not client-id)
      # @param role_rep [Keycloak::Model::RoleRepresentation] role representation
      def create_client_role(id, role_rep)
        url = admin_realm_url + "/clients/#{id}/roles"
        post(url, role_rep.to_json, headers: {content_type: :json})
      end

      # @param id [String] id of client (not client-id)
      # @return [Array<Keycloak::Model::ClientRepresentation>] an array of client representations
      def find_client_roles(id)
        url = admin_realm_url + "/clients/#{id}/roles"
        JSON.parse(get(url)).map { |role| Model::RoleRepresentation.new role }
      end

      # @param id [String] id of client (not client-id)
      # @param name [String] name of role
      # @return [Keycloak::Model::RoleRepresentation] role representation
      def find_client_role_by_name(id, name)
        url = admin_realm_url + "/clients/#{id}/roles/#{name}"
        Model::RoleRepresentation.new JSON.parse(get(url))
      rescue RestClient::NotFound
        nil
      end

      # @param user_id [String] user id
      # @param id_of_client [String] id of client (not client-id)
      # @return [Array<Keycloak::Model::RoleRepresentation>] role representations
      def find_client_roles_for_user(user_id, id_of_client)
        url = admin_realm_url + "/users/#{user_id}/role-mappings/clients/#{id_of_client}"
        JSON.parse(get(url)).map { |role| Model::RoleRepresentation.new role }
      end

      # Only role id and role name are required in role_mappings
      #
      # @param user_id [String] user id
      # @param id_of_client [String] id of client (not client-id)
      # @param role_mappings [Array<Keycloak::Model::RoleRepresentation>] an array of roles
      def add_client_role_mapping(user_id, id_of_client, role_mappings)
        url = admin_realm_url + "/users/#{user_id}/role-mappings/clients/#{id_of_client}"
        post(url, role_mappings.to_json, headers: {content_type: :json})
      end

      def remove_client_role_mapping(user_id, id_of_client, role_mappings)
        url = admin_realm_url + "/users/#{user_id}/role-mappings/clients/#{id_of_client}"
        delete(url, payload: role_mappings.to_json, headers: {content_type: :json})
      end
    end
  end
end

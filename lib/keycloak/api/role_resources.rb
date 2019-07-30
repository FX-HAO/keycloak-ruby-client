module Keycloak
  module API
    module RoleResources
      extend ActiveSupport::Concern
      include Concerns::APIUtil

      # @param role_rep [Keycloak::Model::RoleRepresentation] role representation
      def create_role(role_rep)
        url = admin_realm_url + "/roles"
        post(url, role_rep.to_json, headers: {content_type: :json})
      end

      # @return [Array<Keycloak::Model::RoleRepresentation>] role representations
      def realm_roles
        url = admin_realm_url + "/roles"
        JSON.parse(get(url)).map { |role| Model::RoleRepresentation.new role }
      end

      # @param name [String] name of role
      # @return [Keycloak::Model::RoleRepresentation] role representation
      def find_role_by_name(name)
        url = admin_realm_url + "/roles/#{name}"
        Model::RoleRepresentation.new JSON.parse(get(url).body)
      rescue RestClient::NotFound
        nil
      end

      # @param role_rep [Keycloak::Model::RoleRepresentation] role representation
      # @return [Keycloak::Model::RoleRepresentation] role representation
      def create_or_find_role(role_rep)
        create_role(role_rep) && find_role_by_name(role_rep.name)
      rescue RestClient::Conflict
        find_role_by_name(role_rep.name)
      end

      # @param user_id [String] user id
      # @return [Array<Keycloak::Model::RoleRepresentation>] an array of role representations
      def find_user_realm_roles(user_id)
        JSON.parse(get("#{user_resources_url}/#{user_id}/role-mappings/realm")).map do |role|
          Model::RoleRepresentation.new role
        end
      end

      # Only role id and role name are required in role_mappings
      #
      # @param user_id [String] user id
      # @param role_mappings [Array<Keycloak::Model::RoleRepresentation>] an array of roles
      def add_role_mapping(user_id, role_mappings)
        url = admin_realm_url + "/users/#{user_id}/role-mappings/realm"
        post(url, role_mappings.to_json, headers: {content_type: :json})
      end

      # Only role id and role name are required in role_mappings
      #
      # @param user_id [String] user id
      # @param role_mappings [Array<Keycloak::Model::RoleRepresentation>] an array of roles
      def remove_role_mapping(user_id, role_mappings)
        url = admin_realm_url + "/users/#{user_id}/role-mappings/realm"
        delete(url, payload: role_mappings.to_json, headers: {content_type: :json})
      end
    end
  end
end

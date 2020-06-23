module Keycloak
  module API
    module UserResources
      extend ActiveSupport::Concern
      include Concerns::APIUtil

      def user_resources_url
        admin_realm_url + "/users"
      end

      # Keycloak server doesn't support assign roles at creating user,
      # so we actually implement this in 2 steps.
      #
      # @param user_rep [Keycloak::Model::UserRepresentation] user representation
      # @param roles [Array] an array of roles
      # @return [String] id of the created user
      def create_user(user_rep, roles = [])
        res = post(user_resources_url, user_rep.to_json, headers: {content_type: :json})
        id = res.headers[:location].split("/")[-1]
        return id if roles.empty?
        add_role_mapping(id, roles)
        id
      end

      # @param id [String] user id
      # @return [Keycloak::Model::UserRepresentation] user representation
      def find_user(id)
        Model::UserRepresentation.new JSON.parse(get("#{user_resources_url}/#{id}"))
      end

      # @param id [String] user id
      def update_user(id, user_rep)
        put("#{user_resources_url}/#{id}", user_rep.to_json, headers: {content_type: :json})
      end

      # see https://www.keycloak.org/docs-api/6.0/rest-api/index.html#_users_resource for params details
      #
      # @return [Keycloak::Utils::RepresentationIterator] iterator of users
      def find_users(params = {})
        Utils::RepresentationIterator.new(self, params) do
          res = JSON.parse(get(user_resources_url, params: params))
          res.map { |user| Model::UserRepresentation.new user }
        end
      end

      # @param username [String] username
      # @return [Keycloak::Model::UserRepresentation] user representation
      def find_user_by_username(username)
        find_users({username: username}).to_a[0]
      end

      # @param role [String] role name
      # @param params [Hash] extra params
      # @return [Keycloak::Model::UserRepresentation] user representation
      def find_user_by_role(role, params = {})
        url = "#{admin_realm_url}/roles/#{role}/users"
        Utils::RepresentationIterator.new(self, params) do
          JSON.parse(get(url, params: params)).map { |user| Model::UserRepresentation.new(user) }
        end
      end

      # @param id_of_client [String] id of client (not client-id)
      # @param role [String] role name
      # @param params [Hash] extra params
      # @return [Keycloak::Model::UserRepresentation] user representation
      def find_user_by_client_role(id_of_client, role, params = {})
        url = "#{admin_realm_url}/clients/#{id_of_client}/roles/#{role}/users"
        Utils::RepresentationIterator.new(self, params) do
          JSON.parse(get(url, params: params)).map { |user| Model::UserRepresentation.new(user) }
        end
      end

      # @param id [String] user id
      def delete_user(id)
        delete("#{user_resources_url}/#{id}", headers: {content_type: :json})
      end
    end
  end
end

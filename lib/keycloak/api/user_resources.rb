module Keycloak
  module API
    # see https://www.keycloak.org/docs-api/6.0/rest-api/index.html#_users_resource for params details
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
      def create_user(user_rep, roles = [])
        res = post(user_resources_url, user_rep.to_json, headers: {content_type: :json})
        id = res.headers[:location].split("/")[-1]
        return if roles.empty?
        add_role_mapping(id, roles)
      end

      # @param id [String] user id
      # @return [Keycloak::Model::UserRepresentation] user representation
      def find_user(id)
        Model::UserRepresentation.new JSON.parse(get("#{user_resources_url}/#{id}"))
      end

      # see https://www.keycloak.org/docs-api/6.0/rest-api/index.html#_users_resource for params details
      def find_users(params = {})
        res = JSON.parse(get(user_resources_url, params: params))
        res.map { |user| Model::UserRepresentation.new user }
      end

      def find_user_by_username(username)
        find_users({username: username})[0]
      end

    end
  end
end

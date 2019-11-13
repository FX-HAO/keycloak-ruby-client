module Keycloak
  module API
    module RealmResources
      extend ActiveSupport::Concern
      include Concerns::APIUtil

      # @param realm_rep [Keycloak::Model::RealmRepresentation] realm representation
      # @return [String] realm id
      def create_realm(realm_rep)
        res = post("#{@auth_server_url}/admin/realms/", realm_rep.to_json, headers: {content_type: :json})
        res.headers[:location].split("/")[-1]
      end

      # @param realm [String] realm name
      def delete_realm(realm)
        url = "#{@auth_server_url}/admin/realms/#{realm}"
        delete(url)
      end

      # @param realm [String] realm name
      # @param realm_rep [Keycloak::Model::RealmRepresentation] realm representation
      def update_realm(realm, realm_rep)
        url = "#{@auth_server_url}/admin/realms/#{realm}"
        put(url, realm_rep.to_json, headers: {content_type: :json})
      end

      # @param realm [String] realm name
      # @return [Keycloak::Model::RealmRepresentation] realm representation
      def find_realm(realm)
        url = "#{@auth_server_url}/admin/realms/#{realm}"
        Keycloak::Model::RealmRepresentation.new JSON.parse(get(url))
      end

    end
  end
end

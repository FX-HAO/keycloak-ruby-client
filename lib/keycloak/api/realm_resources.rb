module Keycloak
  module API
    module RealmResources
      extend ActiveSupport::Concern
      include Concerns::APIUtil

      # @param realm_rep [Keycloak::Model::RealmRepresentation] realm representation
      def create_realm(realm_rep)
        post("#{@auth_server_url}/admin/realms/", realm_rep.to_json, headers: {content_type: :json})
      end

      # @param realm [String] realm name
      def delete_realm(realm)
        url = "#{@auth_server_url}/admin/realms/#{realm}"
        delete(url)
      end

    end
  end
end

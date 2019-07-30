module Keycloak
  module API
    module ClientResources
      extend ActiveSupport::Concern
      include Concerns::APIUtil

      # @param client_id [String] client-id (not id of client)
      # @return [Keycloak::Model::ClientRepresentation] client representation
      def find_client_by_client_id(client_id)
        url = admin_realm_url + "/clients"
        data = JSON.parse(get(url, params: { clientId: client_id }).body)
        data[0] && Model::ClientRepresentation.new(data[0])
      rescue RestClient::NotFound
        nil
      end

      # @param id [String] id of client (not client-id)
      # @return [Keycloak::Model::ClientRepresentation] client representation
      def find_client_by_id(id)
        url = admin_realm_url + "/clients/#{id}"
        Model::ClientRepresentation.new JSON.parse(get(url).body)
      rescue RestClient::NotFound
        nil
      end
    end
  end
end

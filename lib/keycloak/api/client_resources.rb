module Keycloak
  module API
    module ClientResources
      extend ActiveSupport::Concern
      include Concerns::APIUtil

      def client_resources_url
        "#{admin_realm_url}/clients"
      end

      # @param client_id [String] client-id (not id of client)
      # @return [Keycloak::Model::ClientRepresentation] client representation
      def find_client_by_client_id(client_id)
        data = JSON.parse(get(client_resources_url, params: { clientId: client_id }).body)
        data[0] && Model::ClientRepresentation.new(data[0])
      rescue RestClient::NotFound
        nil
      end

      # @param id [String] id of client (not client-id)
      # @return [Keycloak::Model::ClientRepresentation] client representation
      def find_client_by_id(id)
        url = client_resources_url + "/#{id}"
        Model::ClientRepresentation.new JSON.parse(get(url).body)
      rescue RestClient::NotFound
        nil
      end

      # @param client_rep [Keycloak::Model::UserRepresentation] client representation
      # @return [String] id of client
      def create_client(client_rep)
        res = post(client_resources_url, client_rep.to_json, headers: {content_type: :json})
        res.headers[:location].split("/")[-1]
      end

      # @param id [String] id of client (not client-id)
      # @param client_rep [Keycloak::Model::UserRepresentation] client representation
      def update_client(id, client_rep)
        url = client_resources_url + "/#{id}"
        put(url, client_rep.to_json, headers: {content_type: :json})
      end
    end
  end
end

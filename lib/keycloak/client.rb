require 'rest_client'

module Keycloak
  class Client
    include API::UserResources
    include API::RoleResources
    include API::ProtectionResources
    include API::ClientResources
    include API::ClientRoleResources
    include API::RealmResources

    attr_reader :auth_server_url, :realm

    def initialize(auth_server_url, realm)
      @auth_server_url = auth_server_url
      @realm = realm
    end

    def realm_url
      "#{@auth_server_url}/realms/#{@realm}"
    end

    def admin_realm_url
      "#{@auth_server_url}/admin/realms/#{@realm}"
    end

    def authenticate(username, password, grant_type, client_id, realm = @realm, auto: true)
      @authenticate_realm = realm
      @authenticate_client_id = client_id
      if auto
        @authenticate_username = username
        @authenticate_password = password
        @authenticate_grant_type = grant_type
      end

      now = DateTime.now
      url = "#{@auth_server_url}/realms/#{realm}/protocol/openid-connect/token"
      res = JSON.parse post(url, {
        username: username,
        password: password,
        grant_type: grant_type,
        client_id: client_id
      }, try_refresh_token: false).body
      @access_token = res["access_token"]
      @refresh_token = res["refresh_token"]
      @refresh_expires_in = now + res["refresh_expires_in"].seconds
      @expires_in = now + res["expires_in"].seconds
      true
    end

    def refresh_token!
      raise "need to call `authenticate` first" unless @refresh_token

      url = "#{@auth_server_url}/realms/#{@authenticate_realm}/protocol/openid-connect/token"
      res = JSON.parse post(url, {
        grant_type: "refresh_token",
        client_id: @authenticate_client_id,
        refresh_token: @refresh_token
      }, try_refresh_token: false)
      @access_token = res["access_token"]
      @refresh_token = res["refresh_token"]
      now = DateTime.now
      @refresh_expires_in = now + res["refresh_expires_in"].seconds
      @expires_in = now + res["expires_in"].seconds
    end

    def access_token_expired?
      @expires_in && @expires_in < DateTime.now
    end

    def refresh_token_expired?
      @refresh_expires_in && @refresh_expires_in < DateTime.now
    end

    def try_refresh_token!
      return unless access_token_expired?

      if !refresh_token_expired?
        refresh_token!
      elsif @authenticate_username && @authenticate_password
        authenticate(@authenticate_username, @authenticate_password, @authenticate_grant_type, @authenticate_client_id, @authenticate_realm, auto: false)
      else
        raise("Refresh token expired, you should re-authenticate to obtain an access token or enable auto authentication")
      end
    end

    def post(url, payload, headers: {}, try_refresh_token: true)
      try_refresh_token! if try_refresh_token

      RestClient.post(url, payload, {
        authorization: "Bearer #{@access_token}",
        accept: "application/json"
      }.merge(headers))
    end

    def get(url, headers: {}, params: {}, try_refresh_token: true)
      try_refresh_token! if try_refresh_token

      RestClient.get(url, {
        authorization: "Bearer #{@access_token}",
        accept: "application/json",
        params: params
      }.merge(headers))
    end

    def delete(url, headers: {}, payload: nil, try_refresh_token: true)
      try_refresh_token! if try_refresh_token

      RestClient::Request.execute(
        method: :delete, url: url, payload: payload,
        headers: {
          authorization: "Bearer #{@access_token}",
          accept: "application/json"
        }.merge(headers)
      )
    end

    def put(url, payload, headers: {}, try_refresh_token: true)
      try_refresh_token! if try_refresh_token

      RestClient.put(url, payload, {
        authorization: "Bearer #{@access_token}",
        accept: "application/json"
      }.merge(headers))
    end
  end
end

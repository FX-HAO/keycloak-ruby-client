module Keycloak
  class AccessToken
    attr_reader :metadata, :jti, :exp, :sub, :azp, :roles, :scope,
                :phone_number, :username, :access_token, :client_roles

    def initialize(realm, access_token, decoded_token, client_id = nil)
      @realm = realm
      @access_token = access_token
      @metadata = decoded_token[0]
      @jti = @metadata["jti"]
      @exp = Time.at(@metadata["exp"]).to_datetime
      @sub = @metadata["sub"]
      @azp = @metadata["azp"]
      if realm_access = @metadata["realm_access"]
        @roles = realm_access["roles"] || []
      end
      if resource_access = @metadata["resource_access"]
        @client_roles = (client_id && resource_access.dig(client_id, "roles")) || []
      end
      @scope = @metadata["scope"]
      @phone_number = @metadata["phone_number"]
      @username = @metadata["username"] || @metadata["preferred_username"]
    end

    def client_id
      @azp
    end

    def authorization
      "Bearer #{@access_token}"
    end

    def expired?
      exp < DateTime.now
    end

    def has_role?(role, include_client_role = true)
      roles.include?(role.to_s) || (include_client_role && has_client_role?(role))
    end

    def has_client_role?(role)
      client_roles.include? role.to_s
    end

    def method_missing(name, *args, &block)
      regex = /^has_(.*?)_role\?$/
      if name.match?(regex)
        return has_role?(name.match(regex)[1])
      end

      super
    end

    def respond_to_missing?(name, include_private = false)
      regex = /^has_(.*?)_role\?$/
      if name.match?(regex)
        return true
      end

      super
    end
  end
end
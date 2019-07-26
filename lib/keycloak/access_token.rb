module Keycloak
  class AccessToken
    attr_reader :metadata, :jti, :exp, :sub, :azp, :roles, :scope,
                :phone_number, :username, :access_token

    def initialize(access_token, decoded_token)
      @access_token = access_token
      @metadata = decoded_token[0]
      @jti = @metadata["jti"]
      @exp = Time.at(@metadata["exp"]).to_datetime
      @sub = @metadata["sub"]
      @azp = @metadata["azp"]
      if realm_access = @metadata["realm_access"]
        @roles = realm_access["roles"] || []
      end
      @scope = @metadata["scope"]
      @phone_number = @metadata["phone_number"]
      @username = @metadata["username"] || @metadata["preferred_username"]
    end

    def authorization
      "Bearer #{@access_token}"
    end

    def expired?
      exp < DateTime.now
    end

    def has_role?(role)
      roles.include? role.to_s
    end
    alias_method :has_spree_role?, :has_role?

    def blocked_at
      nil
    end

    def method_missing(name, *args, &block)
      regex = /^has_(.*?)_role\?$/
      if name.match?(regex)
        return name.match(regex)[1]
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
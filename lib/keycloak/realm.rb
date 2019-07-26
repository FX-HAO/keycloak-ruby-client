module Keycloak
  class Configuration
    attr_accessor :auth_server_url, :realm, :installation_file
  end

  class Realm
    @realms = Concurrent::Map.new

    class << self
      def register(&block)
        return unless block_given?

        cfg = Configuration.new
        block.call(cfg)
        if file = cfg.installation_file
          file_cfg = JSON.parse(File.read(file))
          realm_key = file_cfg['realm'].underscore.to_sym
          @realms[realm_key] = Realm.new(file_cfg['auth-server-url'], file_cfg['realm'])
        else
          realm_key = cfg.realm.underscore.to_sym
          @realms[realm_key] = Realm.new(cfg.auth_server_url, cfg.realm)
        end

        define_singleton_method(realm_key) { @realms[realm_key] }
      end
    end

    attr_accessor :auth_server_url, :realm

    def initialize(auth_server_url, realm)
      @auth_server_url = auth_server_url
      @realm = realm
    end

    def name
      realm
    end

    def parse_access_token(access_token)
      decoded_token = JWT.decode access_token, public_key, false, { :algorithm => 'RS256' }
      AccessToken.new access_token, decoded_token
    end

    def client
      @client ||= Client.new(auth_server_url, realm)
    end

    private

    def public_key
      return @public_key if @public_key

      keys = JSON.parse(RestClient.get("#{auth_server_url}/realms/#{realm}/protocol/openid-connect/certs").body)['keys']
      jwk = JSON::JWK.new(keys[0])
      @public_key = jwk.to_key
    end
  end
end
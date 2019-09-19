module Keycloak
  class Realm
    @realms = Concurrent::Map.new

    class Configuration
      attr_accessor :auth_server_url, :realm, :installation_file
    end

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

    ParseAccessTokenError = Class.new(StandardError)

    def parse_access_token(access_token, client_id:)
      alg = JWT.decode(access_token, nil, false)[1]["alg"]
      decoded_token = JWT.decode access_token, public_keys[alg], true, algorithm: alg
      azp = decoded_token[0]["azp"]
      raise ParseAccessTokenError, "Unexpected client, expect #{client_id}, got #{azp}" if client_id && azp != client_id
      AccessToken.new self, access_token, decoded_token, client_id
    end

    def client
      @client ||= Client.new(auth_server_url, realm)
    end

    private

    def public_keys
      return @public_keys if @public_keys

      keys = JSON.parse(RestClient.get("#{auth_server_url}/realms/#{realm}/protocol/openid-connect/certs").body)['keys']
      @public_keys = {}
      keys.each do |key|
        jwk = JSON::JWK.new(key)
        @public_keys[key["alg"]] = jwk.to_key
      end
      @public_keys
    end
  end
end
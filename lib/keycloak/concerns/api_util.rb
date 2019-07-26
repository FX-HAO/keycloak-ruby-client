module Keycloak
  module Concerns
    module APIUtil
      extend ActiveSupport::Concern

      def realm_url
        raise NotImplementedError
      end

      def admin_realm_url
        raise NotImplementedError
      end

      def post(url, payload, headers: {}, try_refresh_token: true)
        raise NotImplementedError
      end

      def get(url, headers: {}, params: {}, try_refresh_token: true)
        raise NotImplementedError
      end
    end
  end
end

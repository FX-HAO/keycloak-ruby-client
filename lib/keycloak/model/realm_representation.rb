module Keycloak
  module Model
    class RealmRepresentation < BaseRepresentation
      fields :accessCodeLifespan, :accessCodeLifespanLogin, :accessCodeLifespanUserAction,
             :accessTokenLifespan, :accessTokenLifespanForImplicitFlow, :accountTheme,
             :actionTokenGeneratedByAdminLifespan, :actionTokenGeneratedByUserLifespan,
             :adminEventsDetailsEnabled, :adminEventsEnabled, :adminTheme, :attributes,
             :authenticationFlows, :authenticatorConfig, :browserFlow, :browserSecurityHeaders,
             :bruteForceProtected, :clientAuthenticationFlow, :clientScopeMappings, :clientScopes,
             :clients, :components, :defaultDefaultClientScopes, :defaultGroups, :defaultLocale,
             :defaultOptionalClientScopes, :defaultRoles, :defaultSignatureAlgorithm, :directGrantFlow,
             :displayName, :displayNameHtml, :dockerAuthenticationFlow, :duplicateEmailsAllowed,
             :editUsernameAllowed, :emailTheme, :enabled, :enabledEventTypes, :eventsEnabled,
             :eventsExpiration, :eventsListeners, :failureFactor, :federatedUsers, :groups, :id,
             :identityProviderMappers, :identityProviders, :internationalizationEnabled,
             :keycloakVersion, :loginTheme, :loginWithEmailAllowed, :maxDeltaTimeSeconds,
             :maxFailureWaitSeconds, :minimumQuickLoginWaitSeconds, :notBefore, :offlineSessionIdleTimeout,
             :offlineSessionMaxLifespan, :offlineSessionMaxLifespanEnabled, :otpPolicyAlgorithm,
             :otpPolicyDigits, :otpPolicyInitialCounter, :otpPolicyLookAheadWindow, :otpPolicyPeriod,
             :otpPolicyType, :otpSupportedApplications, :passwordPolicy, :permanentLockout,
             :protocolMappers, :quickLoginCheckMilliSeconds, :realm, :refreshTokenMaxReuse,
             :registrationAllowed, :registrationEmailAsUsername, :registrationFlow, :rememberMe,
             :requiredActions, :resetCredentialsFlow, :resetPasswordAllowed, :revokeRefreshToken,
             :roles, :scopeMappings, :smtpServer, :sslRequired, :ssoSessionIdleTimeout,
             :ssoSessionIdleTimeoutRememberMe, :ssoSessionMaxLifespan, :ssoSessionMaxLifespanRememberMe,
             :supportedLocales, :userFederationMappers, :userFederationProviders, :userManagedAccessAllowed,
             :users, :verifyEmail, :waitIncrementSeconds
    end
  end
end
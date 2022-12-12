BeforeDiscovery {
    . $PSScriptRoot\..\Setup.ps1
}

Context "OpenID Configuration Document" {
    # Describe "" {
        It "GET openid-configuration" {
            $ret = Invoke-RestMethod `
                -Method GET `
                -Uri "$($Global:XXX.WebApps["IdentityServer"].Host)/.well-known/openid-configuration"
            
            $ret.issuer | Should -Be "$($Global:XXX.WebApps["IdentityServer"].Host)"
            $ret.jwks_uri | Should -Be "$($Global:XXX.WebApps["IdentityServer"].Host)/.well-known/openid-configuration/jwks"
            $ret.authorization_endpoint | Should -Be "$($Global:XXX.WebApps["IdentityServer"].Host)/connect/authorize"
            $ret.token_endpoint | Should -Be "$($Global:XXX.WebApps["IdentityServer"].Host)/connect/token"
            $ret.userinfo_endpoint | Should -Be "$($Global:XXX.WebApps["IdentityServer"].Host)/connect/userinfo"
            $ret.end_session_endpoint | Should -Be "$($Global:XXX.WebApps["IdentityServer"].Host)/connect/endsession"
            $ret.check_session_iframe | Should -Be "$($Global:XXX.WebApps["IdentityServer"].Host)/connect/checksession"
            $ret.revocation_endpoint | Should -Be "$($Global:XXX.WebApps["IdentityServer"].Host)/connect/revocation"
            $ret.introspection_endpoint | Should -Be "$($Global:XXX.WebApps["IdentityServer"].Host)/connect/introspect"
            $ret.device_authorization_endpoint | Should -Be "$($Global:XXX.WebApps["IdentityServer"].Host)/connect/deviceauthorization"
            $ret.backchannel_authentication_endpoint | Should -Be "$($Global:XXX.WebApps["IdentityServer"].Host)/connect/ciba"
            
            $ret.frontchannel_logout_supported | Should -Be $true
            $ret.frontchannel_logout_session_supported  | Should -Be $true

            $ret.backchannel_logout_session_supported | Should -Be $true
            $ret.backchannel_logout_supported | Should -Be $true
            
            $ret.claims_supported.Count | Should -Be 17
            $ret.claims_supported | Should -Contain "sub"
            $ret.claims_supported | Should -Contain "name"
            $ret.claims_supported | Should -Contain "family_name"
            $ret.claims_supported | Should -Contain "given_name"
            $ret.claims_supported | Should -Contain "middle_name"
            $ret.claims_supported | Should -Contain "nickname"
            $ret.claims_supported | Should -Contain "preferred_username"
            $ret.claims_supported | Should -Contain "profile"
            $ret.claims_supported | Should -Contain "picture"
            $ret.claims_supported | Should -Contain "website"
            $ret.claims_supported | Should -Contain "gender"
            $ret.claims_supported | Should -Contain "birthdate"
            $ret.claims_supported | Should -Contain "zoneinfo"
            $ret.claims_supported | Should -Contain "locale"
            $ret.claims_supported | Should -Contain "updated_at"
            $ret.claims_supported | Should -Contain "email"
            $ret.claims_supported | Should -Contain "email_verified"
            
            $ret.code_challenge_methods_supported.Count | Should -Be 2
            $ret.code_challenge_methods_supported | Should -Contain "plain"
            $ret.code_challenge_methods_supported | Should -Contain "S256"
            
            $ret.frontchannel_logout_session_supported | Should -Be $true
            $ret.frontchannel_logout_supported | Should -Be $true

            $ret.grant_types_supported.Count | Should -Be 7
            $ret.grant_types_supported | Should -Contain "authorization_code"
            $ret.grant_types_supported | Should -Contain "client_credentials"
            $ret.grant_types_supported | Should -Contain "refresh_token"
            $ret.grant_types_supported | Should -Contain "implicit"
            $ret.grant_types_supported | Should -Contain "password"
            $ret.grant_types_supported | Should -Contain "urn:ietf:params:oauth:grant-type:device_code"
            $ret.grant_types_supported | Should -Contain "urn:openid:params:grant-type:ciba"

            $ret.id_token_signing_alg_values_supported.Count | Should -Be 1
            $ret.id_token_signing_alg_values_supported | Should -Contain "RS256"

            $ret.request_parameter_supported | Should -Be $true
            
            $ret.response_modes_supported.Count | Should -Be 3
            $ret.response_modes_supported | Should -Contain "form_post"
            $ret.response_modes_supported | Should -Contain "query"
            $ret.response_modes_supported | Should -Contain "fragment"
            
            $ret.response_types_supported.Count | Should -Be 7
            $ret.response_types_supported | Should -Contain "code"
            $ret.response_types_supported | Should -Contain "token"
            $ret.response_types_supported | Should -Contain "id_token"
            $ret.response_types_supported | Should -Contain "id_token token"
            $ret.response_types_supported | Should -Contain "code id_token"
            $ret.response_types_supported | Should -Contain "code token"
            $ret.response_types_supported | Should -Contain "code id_token token"

            $ret.scopes_supported.Count | Should -Be 6
            $ret.scopes_supported | Should -Contain "openid"
            $ret.scopes_supported | Should -Contain "profile"
            $ret.scopes_supported | Should -Contain "verification"
            $ret.scopes_supported | Should -Contain "api1"
            $ret.scopes_supported | Should -Contain "api2"
            $ret.scopes_supported | Should -Contain "offline_access"

            $ret.subject_types_supported.Count | Should -Be 1
            $ret.subject_types_supported | Should -Contain "public"

            $ret.token_endpoint_auth_methods_supported.Count | Should -Be 2
            $ret.token_endpoint_auth_methods_supported | Should -Contain "client_secret_basic"
            $ret.token_endpoint_auth_methods_supported | Should -Contain "client_secret_post"
        }
    # }
}

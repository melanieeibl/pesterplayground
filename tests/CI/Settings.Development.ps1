# All test are running on a single machine.

$expectedEnvironment = "Development"

if ($Env:ASPNETCORE_ENVIRONMENT -ne $expectedEnvironment) {
    throw "Wrong environment: '$Env:ASPNETCORE_ENVIRONMENT'. Expected '$expectedEnvironment'"
}

$Global:XXX = New-Object PsObject -Property @{
    Initialized = $false
    
    StartAllWebApps = $true
    WebApps = @{
        api = @{ "Name" = "api"; "Host" = "https://localhost:6001"; } 
        IdentityServer = @{ "Name" = "IdentityServer"; "Host" = "https://localhost:5001"; }
        WeatherForecast = @{ "Name" = "WeatherForecast"; "Host" = "https://localhost:5004"; }
        WebClient = @{ "Name" = "WebClient"; "Host" = "https://localhost:5003"; }
    }

    ClientConfigurationM2M = @{
        GrantType = "client_credentials" # client_credentials / password 
        ClientId = "client"
        ClientSecret = "secret"
        Scope = "api1 api2"
    }

    ClientConfigurationInteractive = @{
        GrantType = "password" # client_credentials / password 
        ClientId = "ro.client"
        ClientSecret = "secret"
        UserName = "alice"
        Password = "alice"
        Scope = "api1 api2"
    }
}

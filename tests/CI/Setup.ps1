# Requires PowerShell Core.
#Requires -PSEdition Core
#Requires -Version 7.2

# Run setup only once.
if ($Global:XXX.Initialized) {
    return
}

# Temporär nur ein Environment.
$Env:ASPNETCORE_ENVIRONMENT = "Development"

# Importing the script module.
Import-Module $PSScriptRoot\..\helper\TestHelper.psm1

$Global:SlnRoot = Get-SolutionRoot
Write-Host "Solution root:" $Global:SlnRoot

# Ensure Pester output directory
New-Item -ItemType Directory -Force -Path $Global:SlnRoot\Logs\Pester

# Configure Environment.
switch ($Env:ASPNETCORE_ENVIRONMENT)
{
    "Development" {
        . $PSScriptRoot\Settings.$Env:ASPNETCORE_ENVIRONMENT.ps1
    }
    default { 
        throw "Environment '$Env:ASPNETCORE_ENVIRONMENT' not allowed in this test."
    }
}

# Alle WebApps starten
if ($Global:XXX.StartAllWebApps) {
    foreach ($webApp in $Global:XXX.WebApps.Values) {
        if ($null -eq $(Get-Process -Name $webApp.Name -ErrorAction SilentlyContinue)) {
            $webAppPath = "$Global:SlnRoot\publish\webapps\$($webApp.Name)\publish"

            Push-Location $webAppPath
            try {
                Start-Process -FilePath "$($webApp.Name).exe" -ArgumentList "--URLS $($webApp.Host)"
            }
            finally {
                Pop-Location
            }
        }
    }
}

$Global:XXX.Initialized = $true

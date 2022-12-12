# Requires PowerShell Core.
#Requires -PSEdition Core
#Requires -Version 7.2

# Importing the script module.
Import-Module $PSScriptRoot\..\helper\TestHelper.psm1

# Alle WebApps stoppen
if ($Global:XXX.StartAllWebApps) {
    foreach ($webApp in $Global:XXX.WebApps.Values) {
        $ret = Get-Process -Name $webApp.Name -ErrorAction SilentlyContinue
        if ($null -ne $ret) { Stop-Process -Id $ret.Id }
    }
}

$Global:XXX.Initialized = $false

# Requires PowerShell Core.
#Requires -PSEdition Core
#Requires -Version 7.2

# Is SqlServer Module installed?
$sqlServerModule = Get-InstalledModule -Name SqlServer
if ($null -eq $sqlServerModule) {
    throw "No SqlServer module installed."
    # Install-Module -Name SqlServer
}

# Is Pester installed?
$pesterModule = Get-InstalledModule -Name Pester
if ($null -eq $pesterModule) {
    throw "No Pester module installed."
}

# Is Pester version correct?
$pesterVersion = $pesterModule.Version
if (!$pesterVersion.StartsWith("5.3.")) {
    throw "Pester module $pesterVersion is installed, but version 5.3.x is expected."
}

Import-Module -Name Pester -MinimumVersion 5.0.4

# Set Pester preferences.
Import-Module -Name Pester
$PesterPreference = [PesterConfiguration]::Default
$PesterPreference.Run.PassThru = $true
$PesterPreference.Output.Verbosity = "Detailed" # Accepted values: Diagnostic, Detailed, Normal, Minimal, None

Push-Location $PSScriptRoot

. $PSScriptRoot\Setup.ps1

try {
    $overallResult = @{ "PassedCount" = 0; "FailedCount" = 0; "SkippedCount" = 0; "NotRunCount" = 0 }

    # Run all tests and count errors.
    if ($true) {
        [string[]]$files = @(
            "030_Discovery.Tests.ps1"
            "040_Login.Tests.ps1"
            "050_Api_Authorize.Tests.ps1"
            "060_Api_Exception.Tests.ps1"
            "070_Api_WeatherForecast.Tests.ps1"
            "080_Binary_Commandlet.Tests.ps1"
        )

        $swTests = [Diagnostics.Stopwatch]::StartNew()

        foreach ($file in $files) {
            $configuration = [PesterConfiguration]@{}
            $configuration.Run.Path = "$PSScriptRoot\tests\$file"
            $configuration.TestResult.Enabled = $true
            $configuration.TestResult.OutputFormat = "NUnitXml"
            $configuration.TestResult.OutputPath = "$Global:SlnRoot\Logs\Pester\$file.xml"
            $configuration.Output.Verbosity = "Detailed"

            $result = Invoke-Pester -Configuration  $configuration
        
            $overallResult.PassedCount += $result.PassedCount
            $overallResult.FailedCount += $result.FailedCount
            $overallResult.SkippedCount += $result.SkippedCount
            $overallResult.NotRunCount += $result.NotRunCount
        }
    
        $swTests.Stop()

        Write-Host ""
        Write-Host ""
        if ($overallResult.FailedCount -gt 0) {
            Write-Host "$($overallResult.FailedCount) test(s) have failed 😆. Check the output above for details." -ForegroundColor DarkRed
        }
        else {
            Write-Host "All $($overallResult.PassedCount) tests completed successfully, $($overallResult.SkippedCount) tests have been skipped 😎" -ForegroundColor DarkGreen
        }
        Write-Host "Test runtime: " $swTests.Elapsed.TotalSeconds
    }
}
finally {
    Pop-Location

    . $PSScriptRoot\TearDown.ps1
}

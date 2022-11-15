param (
    [Parameter(Mandatory=$false)]
    [string]
    $TestResultsFilePath = "$PSScriptRoot\..\results\TestResults.xml",

    [Parameter(Mandatory=$false)]
    [string]
    $CodeCoverageResultsFilePath = "$PSScriptRoot\..\results\CodeCoverageResults.xml"
)

$pesterModule = Get-Module -Name Pester -ListAvailable | Where-Object {$_.Version -like '5.*'}
if (!$pesterModule) { 
    try {
        Install-Module -Name Pester -Scope CurrentUser -Force -SkipPublisherCheck -MinimumVersion "5.0"
        $pesterModule = Get-Module -Name Pester -ListAvailable | Where-Object {$_.Version -like '5.*'}
    }
    catch {
        Write-Error "Failed to install the Pester module."
    }
}

Write-Host "Pester version: $($pesterModule.Version.Major).$($pesterModule.Version.Minor).$($pesterModule.Version.Build)"
$pesterModule | Import-Module

$path = Split-Path -Path $PSScriptRoot -Parent

$configuration = New-PesterConfiguration
$configuration.Run.Path = $path
$configuration.Run.TestExtension = "*.Unit.Tests.ps1"
$configuration.Output.Verbosity = "Detailed"
$configuration.TestResult.Enabled = $true
$configuration.TestResult.OutputFormat = "NUnitXml"
$configuration.TestResult.OutputPath = $TestResultsFilePath
$configuration.CodeCoverage.Enabled = $true
$configuration.CodeCoverage.OutputFormat = "JaCoCo"
$configuration.CodeCoverage.OutputPath = $CodeCoverageResultsFilePath

Invoke-Pester -Configuration $configuration

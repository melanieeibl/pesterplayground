Clear-Host

# import module before creating the object
Import-Module Pester

# get default from static property
$configuration = New-PesterConfiguration
$configuration.Run.Path = $PSScriptRoot
$configuration.Filter.Tag = "UnitTest"
$configuration.Filter.ExcludeTag = "AcceptanceTest"
$configuration.Should.ErrorAction = "Continue"
$configuration.CodeCoverage.Enabled = $true
$configuration.CodeCoverage.OutputFormat = "JaCoCo"
$configuration.CodeCoverage.OutputPath = "$PSScriptRoot\..\results\CodeCoverageResults.xml"
$configuration.Output.Verbosity = "Detailed"
$configuration.Output.StackTraceVerbosity = "Full"
$configuration.TestResult.Enabled = $true
$configuration.TestResult.OutputFormat = "NUnitXml"
$configuration.TestResult.OutputPath = "$PSScriptRoot\..\results\TestResults.xml"

# cast whole hashtable to configuration
# $configuration = [PesterConfiguration]@{
#     Run = @{
#         Path = $PSScriptRoot
#     }
#     Filter = @{
#         Tag = 'Acceptance'
#         ExcludeTag = 'WindowsOnly'
#     }
#     Should = @{
#         ErrorAction = 'Continue'
#     }
#     CodeCoverage = @{
#         Enabled = $true
#     }
# }

# cast from empty hashtable to get default
# $configuration = [PesterConfiguration]@{}
# $configuration.Run.Path = $PSScriptRoot
# $configuration.Filter = @{
#         Tag = 'Acceptance'
#         ExcludeTag = 'WindowsOnly'
#     }
# $configuration.Should.ErrorAction = 'Continue'
# $configuration.CodeCoverage.Enabled = $true

Invoke-Pester -Configuration $configuration

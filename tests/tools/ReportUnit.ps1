
. "$PSScriptRoot\ReportUnit.exe" "$PSScriptRoot\..\..\results\TestResults.xml" "$PSScriptRoot\..\..\results\TestResults.html"

& 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' @("$PSScriptRoot\..\..\results\TestResults.html")

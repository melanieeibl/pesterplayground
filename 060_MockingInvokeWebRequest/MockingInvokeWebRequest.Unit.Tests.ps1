Describe 'Mocking native commands' -Tag "UnitTest" {
    It 'Mock Invoke-WebRequest' {
        function GetHTTPHeader ($url) {
            Invoke-WebRequest $url
        }

        Mock Invoke-WebRequest { "$args ist offline ;-)" }

        GetHTTPHeader -url 'https://goooooooooooooogle.de' | Write-Host -BackgroundColor DarkYellow
    }
}

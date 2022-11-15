# For Windows-users: curl used in sample requires Windows 10 1803 / Windows Server 2019 or later
Describe 'Mocking native commands' -Tag "UnitTest" {
    It 'Mock bash' {
        # Windows PowerShell has curl -> Invoke-WebRequest alias. Removing to make sample cross-platform
        while (Test-Path Alias:curl) { Remove-Item Alias:curl }

        function GetHTTPHeader ($url) {
            & curl --url $url `
                -I
        }

        Mock curl { Write-Host "$args" }

        GetHTTPHeader -url 'https://gooogle.com'

        Should -Invoke -CommandName 'curl' -Exactly -Times 1 -ParameterFilter { $args[0] -eq '--url' -and $args[1] -eq 'https://gooogle.com' }

        # By converting args to string (will concat using space by default) you can match a pattern if order might change. remember linebreaks
        Should -Invoke -CommandName 'curl' -Exactly -Times 1 -ParameterFilter { "$args" -match '--url https://gooogle.com -I' }
    }
}

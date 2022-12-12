BeforeDiscovery {
    . $PSScriptRoot\..\Setup.ps1
}

Describe "Access api by Client-Authentication" {
    It "api/values Controller" {
        $uri = "$($Global:XXX.WebApps["api"].Host)/api/values"
        $headers = @{ 
            'Content-Type' = 'application/json' 
        }

        try {
            $ret = Invoke-WebRequest `
                -Method Get `
                -Uri $uri `
                -Headers $Script:headers

            $ret | Should -Not -Be $null
        }
        catch {
            $_.Exception.Response.StatusCode.value__ | Should -Be 500
            # Write-Host $_.Exception.Message
            # Write-Host $_.ErrorDetails.Message
            # throw
        }
    }
}

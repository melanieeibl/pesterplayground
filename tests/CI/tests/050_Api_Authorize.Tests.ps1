BeforeDiscovery {
    . $PSScriptRoot\..\Setup.ps1
}

Describe "Access api Without Authentication" {
    It "identity Controller" {
        $uri = "$($Global:XXX.WebApps["api"].Host)/identity"
        $headers = @{ 
            'Content-Type'  = 'application/json' 
        }
        { Invoke-RestMethod `
            -Method Get `
            -Uri $uri `
            -Headers $headers } | Should -Throw
    }
}

Describe "Access api by Client-Authentication" {
    BeforeEach {
        $Script:token = New-Token -configuration $Global:XXX.ClientConfigurationM2M

        $Script:headers = @{ 
            'Content-Type'  = 'application/json' 
            'Authorization' = "Bearer $($Script:token.access_token)"
        }
    }

    It "identity Controller" {
        $uri = "$($Global:XXX.WebApps["api"].Host)/identity"
        $ret = Invoke-RestMethod `
            -Method Get `
            -Uri $uri `
            -Headers $Script:headers

        foreach ($item in $ret) {
            Write-Host "$($item.type) - $($item.value)"
        }

        $ret | Should -Not -Be $null
    }
}

Describe "Access api by ROPC-Authentication" -Skip {
    BeforeEach {
        $Script:token = New-Token -configuration $Global:XXX.ClientConfigurationInteractive

        $Script:headers = @{ 
            'Content-Type'  = 'application/json' 
            'Authorization' = "Bearer $($Script:token.access_token)"
        }
    }
        
    It "identity Controller" {
        $uri = "$($Global:XXX.WebApps["api"].Host)/identity"
        $ret = Invoke-RestMethod `
            -Method Get `
            -Uri $uri `
            -Headers $Script:headers

        foreach ($item in $ret) {
            Write-Host "$($item.type) - $($item.value)"
        }
                
        $ret | Should -Not -Be $null
    }
}

BeforeDiscovery {
    . $PSScriptRoot\..\Setup.ps1
}

BeforeAll {
    [System.Reflection.Assembly]::LoadFrom("$(Get-SolutionRoot)\publish\webapps\WeatherForecast\publish\WeatherForecast.dll")
}

Describe "Access WeatherForecast api" {
    It "Get api/WeatherForecast List" {
        $uri = "$($Global:XXX.WebApps["WeatherForecast"].Host)/WeatherForecast"
    
        $ret = Invoke-WebRequest `
            -Method Get `
            -Uri $uri

        $list = [Newtonsoft.Json.JsonConvert]::DeserializeObject($ret.Content, [System.Collections.Generic.List[WeatherForecast.WeatherForecast]])

        $list | Should -Not -Be $null
        $Script:count = $($list).Count
    }

    It "Post api/WeatherForecast" {
        $newObject = New-Object WeatherForecast.WeatherForecast
        $newObject.Date = [datetime]::Today
        $newObject.TemperatureC = 20
        $newObject.Summary = "Hallo PowerShell ❤️"
        
        $body = $newObject | ConvertTo-Json
        
        $ret = Invoke-RestMethod `
            -Method Post `
            -Uri "$($Global:XXX.WebApps["WeatherForecast"].Host)/WeatherForecast" `
            -Headers @{ 'Content-Type' = 'application/json' } `
            -Body $body
    
        $ret | Should -Not -Be $null
    }

    It "Get api/WeatherForecast List" {
        $uri = "$($Global:XXX.WebApps["WeatherForecast"].Host)/WeatherForecast"
    
        $ret = Invoke-WebRequest `
            -Method Get `
            -Uri $uri

        $list = [Newtonsoft.Json.JsonConvert]::DeserializeObject($ret.Content, [System.Collections.Generic.List[WeatherForecast.WeatherForecast]])

        $list | Should -Not -Be $null
        $($list).Count | Should -BeGreaterThan $Script:count
        $Script:object = $list
    }

    It "Get api/WeatherForecast" {
        $body = [datetime]::Today

        $ret = Invoke-RestMethod `
            -Method Get `
            -Uri "$($Global:XXX.WebApps["WeatherForecast"].Host)/WeatherForecast" `
            -Headers @{ 'Content-Type' = 'application/json' } `
            -Body $body.ToString()

        $ret | Should -Not -Be $null
    }
}

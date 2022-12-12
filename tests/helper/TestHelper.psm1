# General test functions.

# Requires PowerShell Core. Only check major version here.
#Requires -Version 7

function Get-SolutionRoot() {
    <#
.SYNOPSIS
    Searches for .git folder in the current location and recursively in the parent folders.
#>
    [cmdletBinding()]
    param()

    try {
        $path = Split-Path -Parent $Script:MyInvocation.MyCommand.Path

        while ($true) {
            if (!([string]::IsNullOrEmpty($path))) {
                $gitFolder = Get-ChildItem -Path $path  -Filter *.git -Recurse -Force
                if ($null -ne $gitFolder) {
                    return $gitFolder.Parent.FullName
                }
                else {
                    $path = $(Get-Item $path).Parent.FullName
                }
            }
            else {
                return $PSScriptRoot
                break
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}
Export-ModuleMember -Function Get-SolutionRoot

function New-Browser {
    # https://administrator.de/tutorial/powershell-einfuehrung-in-die-webbrowser-automation-mit-selenium-webdriver-1197173647.html

    param(
        [Parameter(mandatory=$true)][ValidateSet('Chrome','Edge','Firefox')][string]$browser,
        [Parameter(mandatory=$false)][bool]$HideCommandPrompt = $true,
        [Parameter(mandatory=$false)][string]$driverversion = ''
    )
    $driver = $null
    
    function Load-NugetAssembly {
        [CmdletBinding()]
        param(
            [string]$url,
            [string]$name,
            [string]$zipinternalpath,
            [switch]$downloadonly
        )
        if($psscriptroot -ne ''){
            $localpath = join-path $psscriptroot $name
        }else{
            $localpath = join-path $env:TEMP $name
        }
        $tmp = "$env:TEMP\$([IO.Path]::GetRandomFileName())"
        $zip = $null
        try{
            if(!(Test-Path $localpath)){
                Add-Type -A System.IO.Compression.FileSystem
                write-host "Downloading and extracting required library '$name' ... " -F Green -NoNewline
                (New-Object System.Net.WebClient).DownloadFile($url, $tmp)
                $zip = [System.IO.Compression.ZipFile]::OpenRead($tmp)
                $zip.Entries | ?{$_.Fullname -eq $zipinternalpath} | %{
                    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_,$localpath)
                }
	            Unblock-File -Path $localpath
                write-host "OK" -F Green
            }
            if(!$downloadonly.IsPresent){
                Add-Type -LiteralPath $localpath -EA Stop
            }
        
        }catch{
            throw "Error: $($_.Exception.Message)"
        }finally{
            if ($zip){$zip.Dispose()}
            if(Test-Path $tmp){del $tmp -Force -EA 0}
        }  
    }

    # Load Selenium Webdriver .NET Assembly
    
    Load-NugetAssembly 'https://www.nuget.org/api/v2/package/Selenium.WebDriver/4.5.0' -name 'WebDriver.dll' -zipinternalpath 'lib/net5.0/WebDriver.dll' -EA Stop

    if($psscriptroot -ne ''){
        $driverpath = $psscriptroot
    }else{
        $driverpath = $env:TEMP
    }
    switch($browser){
        'Chrome' {
            # $chrome = Get-Package -Name 'Google Chrome' -EA SilentlyContinue | select -F 1
            # if (!$chrome){
            #     throw "Google Chrome Browser not installed."
            #     return
            # }
            Load-NugetAssembly "https://www.nuget.org/api/v2/package/Selenium.WebDriver.ChromeDriver/$driverversion" -name 'chromedriver.exe' -zipinternalpath 'driver/win32/chromedriver.exe' -downloadonly -EA Stop
            # create driver service
            $dService = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService($driverpath)
            # hide command prompt window
            $dService.HideCommandPromptWindow = $HideCommandPrompt
            # create driver object
            $driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver $dService
        }
        'Edge' {
            # $edge = Get-Package -Name 'Microsoft Edge' -EA SilentlyContinue | select -F 1
            # if (!$edge){
            #     throw "Microsoft Edge Browser not installed."
            #     return
            # }
            Load-NugetAssembly "https://www.nuget.org/api/v2/package/Selenium.WebDriver.MSEdgeDriver/$driverversion" -name 'msedgedriver.exe' -zipinternalpath 'driver/win64/msedgedriver.exe' -downloadonly -EA Stop
            # create driver service
            $dService = [OpenQA.Selenium.Edge.EdgeDriverService]::CreateDefaultService($driverpath)
            # hide command prompt window
            $dService.HideCommandPromptWindow = $HideCommandPrompt
            # create driver object
            $driver = New-Object OpenQA.Selenium.Edge.EdgeDriver $dService
        }
        'Firefox' {
            # $ff = Get-Package -Name "Mozilla Firefox*" -EA SilentlyContinue | select -F 1
            # if (!$ff){
            #     throw "Mozilla Firefox Browser not installed."
            #     return
            # }
            Load-NugetAssembly "https://www.nuget.org/api/v2/package/Selenium.WebDriver.GeckoDriver/$driverversion" -name 'geckodriver.exe' -zipinternalpath 'driver/win64/geckodriver.exe' -downloadonly -EA Stop
            # create driver service
            $dService = [OpenQA.Selenium.Firefox.FirefoxDriverService]::CreateDefaultService($driverpath)
            # hide command prompt window
            $dService.HideCommandPromptWindow = $HideCommandPrompt
            # create driver object
            $driver = New-Object OpenQA.Selenium.Firefox.FirefoxDriver $dService
        }
    }
    return $driver
}
Export-ModuleMember -Function New-Browser

function New-Token {
    param(
        [Parameter(mandatory = $true)] [System.Object] $configuration
    )

    if ($configuration.GrantType -eq "client_credentials") {
        $body = @{
            grant_type    = $configuration.GrantType
            client_id     = $configuration.ClientId
            client_secret = $configuration.ClientSecret
            scope         = $configuration.Scope
        }
    }
    elseif ($configuration.GrantType -eq "password") {
        $body = @{
            grant_type    = $configuration.GrantType
            client_id     = $configuration.ClientId
            client_secret = $configuration.ClientSecret
            username      = $configuration.UserName
            password      = $configuration.Password
            scope         = $configuration.Scope
        }
    }

    [System.Uri]$uri = [System.Uri]"$($Global:XXX.WebApps["IdentityServer"].Host)/connect/token"

    $token = Invoke-RestMethod `
        -Method Post `
        -Body $body `
        -Uri $uri
     
    return $token
}
Export-ModuleMember -Function New-Token

function Write-JwtPayload {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $token
    )

    function Convert-FromBase64StringWithNoPadding([string]$data) {
        $data = $data.Replace('-', '+').Replace('_', '/')
        switch ($data.Length % 4) {
            0 { break }
            2 { $data += '==' }
            3 { $data += '=' }
            default { throw New-Object ArgumentException('data') }
        }
        return [System.Convert]::FromBase64String($data)
    }

    $parts = $token.Split('.');
    $baseDecoded = Convert-FromBase64StringWithNoPadding($parts[1])
    $decoded = [System.Text.Encoding]::UTF8.GetString($baseDecoded)

    Write-Host "`JWT payload: `n" -foreground Yellow
    $decoded = $decoded | ConvertFrom-Json | ConvertTo-Json
    Write-Host $decoded -foreground White
}
Export-ModuleMember -Function Write-JwtPayload

function Write-Token {
    param (
        [Parameter(mandatory = $true)]
        [PSObject]
        $token
    )
    
    Write-Host "`ACCESSTOKEN: `n" -foreground Yellow
    Write-Host ($token.access_token | Format-Table -Wrap | Out-String ) -foreground White
}
Export-ModuleMember -Function Write-Token

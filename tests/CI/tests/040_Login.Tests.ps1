BeforeDiscovery {
    . $PSScriptRoot\..\Setup.ps1
}

BeforeAll {
    # Browser öffnen
    $Script:driver = New-Browser -browser Edge
}

# Context "" {
    Describe "Benutzer meldet sich beim IdentityServer an." {
        It "GET diagnostics => Redirect auf Account/Login" {
            $Script:driver.Navigate().GotoURL("$($Global:XXX.WebApps["IdentityServer"].Host)/diagnostics")
            
            # Screenshot der Zielseite
            $Script:driver.GetScreenshot().SaveAsFile("$Global:SlnRoot\Logs\Pester\040_Login_040.png",'png')

            # Redirect auf Auth/Login
            $Script:driver.Url.Contains("Account/Login") | Should -Be $true
        }

        It "Nach Eingabe von E-Mail und Password Redirect auf Account" {
            $Script:driver.FindElement([OpenQA.Selenium.By]::Id("Input_Username")).SendKeys("alice")
            $Script:driver.FindElement([OpenQA.Selenium.By]::Id("Input_Password")).SendKeys("alice")

            # Button "Login" wird gedrückt
            $Script:driver.FindElement([OpenQA.Selenium.By]::ClassName(("btn-primary"))).SendKeys([OpenQA.Selenium.Keys]::ENTER)

            # Screenshot der Zielseite
            $Script:driver.GetScreenshot().SaveAsFile("$Global:SlnRoot\Logs\Pester\040_Login_050.png",'png')

            # Die Ziel-Url ist "Account"
            $Script:driver.Url.Contains("diagnostics") | Should -Be $true
        }
    }
# }

AfterAll {
    # Browser schließen
    $Script:driver.Quit()
}

BeforeDiscovery {
    $prefix = ">>>"
}

Describe "Mocking Write-Host" -Tag "UnitTest" {
    BeforeAll{
        Mock Write-Host { throw "Use Mock!" }
    }

    It "$($prefix)Throws exception" {
        { Write-Host "Something happens" } | Should -Throw
    }

    Context "Overriding Mock and test" {
        BeforeAll{
            Mock Write-Host { return "mocked Write-Host" } -Verifiable -ParameterFilter { $Object -eq "XXX" }
        }

        It "$($prefix)All mocks are invoked" {
            Write-Host "XXX"
            Should -InvokeVerifiable
        }

        It "$($prefix)Returns 'Invoke mocked Write-Host'" {
            Write-Host "XXX" | Should -Be "mocked Write-Host"
        }

        It "$($prefix)Write-Host invoked with parameter" {
            Write-Host "XXX"
            Should -Invoke -CommandName Write-Host -Times 1 -ParameterFilter { $Object -eq "XXX" }
        }
    }
}

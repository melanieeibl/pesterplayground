BeforeAll {
    function Get-Stuff {
        return Get-Random -Minimum 0 -Maximum 10
    }
}

Describe "Mocking Get-Random" -Tag "UnitTest" {
    It "Test Get-Stuff" {
        Mock Get-Random { return 7 }
        Get-Stuff | Should -Be 7
    }
}

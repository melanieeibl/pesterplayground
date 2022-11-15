BeforeAll{
    function Build-String ([string]$prefix, [string]$string, [string]$suffix) {
        [string]$result = '{0}{1}{2}' -f $prefix.Trim(), $string.Trim(), $suffix.Trim()
        return $result
    }

    function Get-Prefix{
        [string]$result = "RealPrefix"
        return $result.Trim()
    }

    function Get-Suffix {
        [string]$result = "RealSuffix"
        return $result
    }

    function Get-String ($string) {
        [string]$prefix = Get-Prefix
        [string]$suffix = Get-Suffix
        if ($prefix -eq "NoPrefix") { return "yyy" }
        [string]$result = Build-String -prefix $prefix -string $string -suffix $suffix
        return $result
    }
}

Describe "Build string" -Tag "UnitTest" {
    Context "is optional 1" {
        BeforeEach{
            Mock Get-Prefix { return "MockedPrefix" }
            Mock Get-Suffix { return "MockedSuffix" }
            # Mock Build-String { return "xxx" } -Verifiable -ParameterFilter { $prefix -eq "MockedPrefix", $suffix -eq "MockedSuffix" } Bug
            Mock Build-String { return "xxx" } -Verifiable -ParameterFilter { $prefix -eq "MockedPrefix" }

            $result = Get-String
        }

        It "All mocks are invoked" {
            Should -InvokeVerifiable
        }

        It "Returns 'xxx'" {
            $result | Should -Be "xxx"
        }
    }

    Context "is optional 2" {
        BeforeEach{
            Mock Get-Prefix { return "NoPrefix" }
            Mock Get-Suffix { return "MockedSuffix" }
            Mock Build-String {}

            $result = Get-String
        }

        It "Should not call Build-String" {
            Should -Invoke -CommandName Build-String -Times 0 -ParameterFilter { $prefix -eq "NoPrefix" }
        }

        It "Returns 'yyy'" {
            $result | Should -Be "yyy"
        }
    }
}
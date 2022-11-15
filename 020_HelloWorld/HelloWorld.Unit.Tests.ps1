Import-Module Pester

BeforeAll {
    # Arrange
    . $PSScriptRoot\HelloWorld.ps1
}

# Describe "Weitere Strukturierungsebene" {
Context "Hello World" -Tag "UnitTest" {
    It 'Output Should Be Hello World!' {
        # Act
        $ret = Write-HelloWorld

        # Assert
        $ret | Should -Be 'Hello World!'
    }
}
# }

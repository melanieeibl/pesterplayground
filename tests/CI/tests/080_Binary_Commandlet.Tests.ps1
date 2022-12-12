BeforeDiscovery {
    . $PSScriptRoot\..\Setup.ps1
}

BeforeAll {
    # Importing the binary module.
    Import-Module "$($Global:SlnRoot)\publish\common\MyBinaryModule\publish\MyBinaryModule.dll"
}

Describe "Invoke Commandlet" {
    It "Get-Echo" {
        $ret = Get-Echo
    
        $ret | Should -Be "This is your echo!"
    }
}

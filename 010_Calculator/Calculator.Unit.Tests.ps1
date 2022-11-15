BeforeAll {
    # Test
    . $PSScriptRoot\Calculator.ps1
}

Describe 'Calculator' -Tag "UnitTest" {
    Context 'When calling add' {
        It '<a> plus <b> should equal <c>' -ForEach @(
            @{ a = 4; b = 5; c = 9}
            @{ a = 9; b = 9; c = 17}
            @{ a = 7; b = 5; c = 12}
            @{ a = 40; b = 50; c = 90}
        ) {
            add -a $a -b $b | Should -Be $c
        }

        It "-2 plus 10 should equal 8" {
            add -a -2 -b 10 | Should -Be 8
        }
    }

    Context 'When calling subtract' {
        It '7 minus 3 should equal 4' {
            subtract -a 7 -b 3 | Should -Be 4
        }

        It "-5 minus 5 should equal -10" {
            subtract -a -5 -b 5 | Should -Be -10
        }
    }

    Context 'When calling multiply' {
        It '7 times 3 should equal 21' {
            multiply -a 7 -b 3 | Should -Be 21
        }

        It "-5 times 5 should equal -50" {
            multiply -a -5 -b 5 | Should -Be -25
        }
    }
    
    Context 'When calling divide' {
        It '21 divided by 3 should equal 7' {
            divide -a 21 -b 3 | Should -Be 7
        }

        It "21 divided by 0 should throw exception" {
            # divide -a 21 -b 0 | Should -Be 0
            { divide -a 21 -b 0 } | Should -Throw
        }
    }
}

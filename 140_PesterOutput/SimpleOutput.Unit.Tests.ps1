BeforeAll {
    . $PSScriptRoot\Get-Emoji.ps1
}

Describe "Get-Emoji" -Tag "UnitTest" {
    Context "Lookup by whole name" -Tag "UnitTest" {
        It "Returns 🌵 (cactus)" {
            Get-Emoji -Name cactus | Should -Be '🌵'
        }

        It "Returns 🦒 (giraffe)" {
            Get-Emoji -Name giraffe | Should -Be '🦒'
        }
    }

    Context "Lookup by wildcard" -Tag "UnitTest" {
        Context "by prefix" {
            BeforeAll {
                $emojis = Get-Emoji -Name pen*
            }

            It "Returns ✏️ (pencil)" {
                $emojis | Should -Contain "✏️"
            }

            It "Returns 🐧 (penguin)" {
                $emojis | Should -Contain "🐧"
            }

            It "Returns 😔 (pensive)" {
                $emojis | Should -Contain "😔"
            }
        }

        Context "by contains" -Tag "UnitTest" {
            BeforeAll {
                $emojis = Get-Emoji -Name *smiling*
            }

            It "Returns 🙂 (slightly smiling face)" {
                $emojis | Should -Contain "🙂"
            }

            It "Returns 😁 (beaming face with smiling eyes)" {
                $emojis | Should -Contain "😁"
            }

            It "Returns 😊 (smiling face with smiling eyes)" {
                $emojis | Should -Contain "😊"
            }
        }
    }

    Describe "Data driven Get-Emoji" -Tag "AcceptanceTest" {
        It "Returns <expected> (<name>)" -ForEach @(
            @{ Name = "cactus"; Expected = '🌵'}
            @{ Name = "giraffe"; Expected = '🦒'}
            @{ Name = "red-apple"; Expected = '🍎'}
            @{ Name = "pencil"; Expected = '✏️'}
            @{ Name = "penguin"; Expected = '🐧'}
            @{ Name = "smiling-face-with-smiling-eyes"; Expected = '😊'}
        ) {
            Get-Emoji -Name $name | Should -Be $expected
        }
    }
}
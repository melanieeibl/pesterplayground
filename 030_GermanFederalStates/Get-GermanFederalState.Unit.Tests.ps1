BeforeAll {
    . $PSScriptRoot/Get-GermanFederalState.ps1
}

Describe "Get-GermanFederalState" -Tag "UnitTest" {
    It "Given no parameters, it lists all 16 planets" {
        $allGermanFederalStates = Get-GermanFederalState
        $allGermanFederalStates.Count | Should -Be 16
    }

    It "Berlin is the third federal state in Germany" {
        $allGermanFederalStates = Get-GermanFederalState
        $allGermanFederalStates[2].Name | Should -Be "Berlin"
    }

    It "Mallorca is not a federal state of Germany" {
        $allGermanFederalStates = Get-GermanFederalState
        $mallorcas = $allGermanFederalStates | Where-Object Name -EQ "Mallorca"
        $mallorcas.Count | Should -Be 0
    }

    It "Planets have this order: 'Baden-Württemberg, Bayern, Berlin, Brandenburg, Bremen, 
            Hamburg, Hessen, Mecklenburg-Vorpommern, Niedersachsen, 
            Nordrhein-Westfalen, Rheinland-Pfalz, Saarland, Sachsen, 
            Sachsen-Anhalt, Schleswig-Holstein, Thüringen'" {
        $allGermanFederalStates = Get-GermanFederalState
        $germanFederalStatesInOrder = $allGermanFederalStates.Name -join ', '
        $germanFederalStatesInOrder | Should -Be "Baden-Württemberg, Bayern, Berlin, Brandenburg, Bremen, " &
                "Hamburg, Hessen, Mecklenburg-Vorpommern, Niedersachsen, " &
                "Nordrhein-Westfalen, Rheinland-Pfalz, Saarland, Sachsen, " &
                "Sachsen-Anhalt, Schleswig-Holstein, Thüringen"
    }
}

BeforeAll {
    function forAll ($input1) {
         "realForAll" 
    }
}

Describe "Mock in It-block" -Tag "UnitTest" {
    BeforeEach {
        function forEach1 ($input1) {
            "realForEach" 
        }
    }

    It "Function call forAll" {
        forAll 4711 | Should -Be "realForAll"
    }

    It "Simple mocking forAll" {
        Mock forAll { "mockedForAll" }
        forAll 4711 | Should -Be "mockedForAll"
        Should -Invoke -CommandName forAll -Times 1
    }

    It "Parametrized mocking forAll" {
        Mock forAll { "mockedForAll" } -ParameterFilter { $input1 -eq 10 }
        forAll 10 | Should -Be "mockedForAll"
        Should -Invoke -CommandName forAll -Times 1 -ParameterFilter { $input1 -eq 10 }
    }

    It "Function call forEach" {
        forEach1 4711 | Should -Be "realForEach"
    }

    It "Simple mocking forEach" {
        Mock forEach1 { "mockedForEach" }
        forEach1 4711 | Should -Be "mockedForEach"
        Should -Invoke -CommandName forEach1 -Times 1
    }

    It "Parametrized mocking forEach" {
        Mock forEach1 { "mockedForEach" } -ParameterFilter { $input1 -eq 10 }
        forEach1 10 | Should -Be "mockedForEach"
        Should -Invoke -CommandName forEach1 -Times 1 -ParameterFilter { $input1 -eq 10 }
    }
}

Describe "mock in BeforeEach-block" {
    BeforeEach {
        function forEach2 ($input1) {
            "realForEach" 
        }
 
       Mock forEach2 { "mockedForEach" } -ParameterFilter { $input1 -eq 10 }
    }

    It "Function call forEach calls mock" {
        forEach2 10 | Should -Be "mockedForEach"
        Should -Invoke -CommandName forEach2 -Times 1
    }

    It "Parametrized mocking forEach" {
        forEach2 10 | Should -Be "mockedForEach"
        Should -Invoke -CommandName forEach2 -Times 1 -ParameterFilter { $input1 -eq 10 }
        Should -Invoke -CommandName forEach2 -Times 0 -ParameterFilter { $input1 -eq 4711 }
    }
}
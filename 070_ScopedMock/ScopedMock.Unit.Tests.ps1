BeforeAll {
    function forAll ($input1) {
        "realForAll" 
    }
}

Describe "Mock in It-block" -Tag "UnitTest" {
    BeforeEach {
        function forEach1 ($input1) {
            "realForEach1" 
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
        forAll | Should -Be "realForAll"
        forAll 4711 | Should -Be "realForAll"
        Should -Invoke -CommandName forAll -Times 1 -ParameterFilter { $input1 -eq 10 }
    }

    It "Function call forEach1" {
        forEach1 4711 | Should -Be "realForEach1"
    }

    It "Simple mocking forEach1" {
        Mock forEach1 { "mockedForEach" }
        forEach1 4711 | Should -Be "mockedForEach"
        Should -Invoke -CommandName forEach1 -Times 1
    }

    It "Parametrized mocking forEach1" {
        Mock forEach1 { "mockedForEach1" } -ParameterFilter { $input1 -eq 10 }
        forEach1 10 | Should -Be "mockedForEach1"
        Should -Invoke -CommandName forEach1 -Times 1 -ParameterFilter { $input1 -eq 10 }
    }
}

Describe "mock in BeforeEach-block" {
    BeforeEach {
        function forEach2 ($input1) {
            "realForEach2" 
        }
 
        Mock forEach2 { "mockedForEach2" } -ParameterFilter { $input1 -eq 10 }
    }

    It "Function call forEach2 calls mock" {
        forEach2 10 | Should -Be "mockedForEach2"
        Should -Invoke -CommandName forEach2 -Times 1
    }

    It "Parametrized mocking forEach2" {
        forEach2 10 | Should -Be "mockedForEach2"
        Should -Invoke -CommandName forEach2 -Times 1 -ParameterFilter { $input1 -eq 10 }
        Should -Invoke -CommandName forEach2 -Times 0 -ParameterFilter { $input1 -eq 4711 }
    }
}
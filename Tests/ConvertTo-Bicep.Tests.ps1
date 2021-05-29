try {
    $ScriptDirectory = Split-Path -Path $PSCommandPath -Parent
    Import-Module -FullyQualifiedName "$ScriptDirectory\..\Source\Bicep.psd1"
}
catch {
    Throw "Unable to import Bicep module. $_"
}

InModuleScope Bicep {
    BeforeAll {
        $ScriptDirectory = Split-Path -Path $PSCommandPath -Parent
    }
    Describe 'ConvertTo-Bicep' {
        
        Context 'When it works' {
            It 'Decompile to bicep file' {
                ConvertTo-Bicep "$ScriptDirectory\supportFiles\workingARMTemplate.json" -AsString | Should -Not -BeNullOrEmpty
            }
        }
        Context 'When it does not work' {
            It 'Does not generate ARM template' {
                ConvertTo-Bicep -Path "$ScriptDirectory\supportFiles\brokenARMTemplate.json" -AsString | Should -Not -BeNullOrEmpty
            }
            
        }
    }
}
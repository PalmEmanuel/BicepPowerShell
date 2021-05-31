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
    Describe 'New-BicepParameterFile' {
        
        Context 'When it works' {            
            It 'New parameter file with all parameters' {
                $file="$ScriptDirectory\supportFiles\workingBicep.bicep"
                New-BicepParameterFile -Path $file -Parameters All
                $parameterFile = $file -replace '\.bicep', '.parameters.json'
                Get-Content -Path $parameterFile -Raw | Should -Not -BeNullOrEmpty
            }        
        }
        Context 'When it does not work' { 
            It 'Does not generate a parameter file' {
                New-BicepParameterFile -Path "$ScriptDirectory\supportFiles\brokenBicep.bicep" -ErrorAction SilentlyContinue | Should -BeLike '*Error BCP018: Expected the "}" character at this location.'
            }            
        }
    }
}
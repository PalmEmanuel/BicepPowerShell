function Test-BicepFile {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess)]
    param (
        [Parameter(ParameterSetName = 'Default', Position = 1)]
        [string]$Path = $pwd.path,
        
        [Parameter(ParameterSetName = 'Default')]
        [string[]]$ExcludeFile
    )

    begin {
        if (-not $Script:ModuleVersionChecked) {
            TestModuleVersion
        } 
        $DLLPath = [Bicep.Core.Workspaces.Workspace].Assembly.Location
        $DllFile = Get-Item -Path $DLLPath
        $FullVersion = $DllFile.VersionInfo.ProductVersion.Split('+')[0]
        Write-Host -Message "Using Bicep version: $FullVersion" -ForegroundColor Yellow
        
    }

    process {
        $files = Get-Childitem -Path $Path *.bicep -File
        if ($files) {
            foreach ($file in $files) {
                if ($file.Name -notin $ExcludeFile) {                 
                    $ARMTemplate = ParseBicep -Path $file.FullName
                }
            }
        }
        else {
            Write-Host "No bicep files located in path $Path"
        }
    }
}
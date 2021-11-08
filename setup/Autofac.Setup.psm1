<#
.SYNOPSIS
    Gets the set of directories in which projects are available for compile/processing.

.PARAMETER RootPath
    Path where searching for project directories should begin.
#>
function Get-DotNetProjectDirectory {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $False)]
        [ValidateNotNullOrEmpty()]
        [string]
        $RootPath
    )

    Get-ChildItem -Path $RootPath -Recurse -Include "*.csproj" | Select-Object @{ Name = "ParentFolder"; Expression = { $_.Directory.FullName.TrimEnd("\") } } | Select-Object -ExpandProperty ParentFolder
}

<#
.SYNOPSIS
    Runs the dotnet CLI install script from GitHub to install a project-local
    copy of the CLI.
#>
function Install-DotNetCli {
    [CmdletBinding()]
    Param(
        $InstallDir,
        [string]
        $Version = "Latest"
    )

    Write-Message "Installing .NET SDK version $Version"
    
    # Download the dotnet CLI install script
    if ($IsWindows) {
        $scriptFile = Join-Path $env:RUNNER_TEMP 'dotnet-install.ps1';

        if (!(Test-Path $scriptFile)) {
            Invoke-WebRequest "https://dot.net/v1/dotnet-install.ps1" -OutFile $scriptFile
        }

        & $scriptFile -InstallDir "$InstallDir" -Version $Version
    } else {
        
        $scriptFile = Join-Path $env:RUNNER_TEMP 'dotnet-install.sh';

        if (!(Test-Path $scriptFile)) {
            Invoke-WebRequest "https://dot.net/v1/dotnet-install.sh" -OutFile $scriptFile
        }

        & bash $scriptFile --install-dir "$InstallDir" --version $Version
    }
}

<#
.SYNOPSIS
    Writes a build progress message to the host.

.PARAMETER Message
    The message to write.
#>
function Write-Message {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $False)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Message
    )

    Write-Host "[BUILD] $Message" -ForegroundColor Cyan
}

<#
.SYNOPSIS
    Calls Resolve-Path but works for files that don't exist.
.REMARKS
    From http://devhawk.net/blog/2010/1/22/fixing-powershells-busted-resolve-path-cmdlet
#>
function Resolve-Path-Force {
    param (
        [string] $FileName
    )

    $FileName = Resolve-Path $FileName -ErrorAction SilentlyContinue `
                                       -ErrorVariable _frperror
    if (-not($FileName)) {
        $FileName = $_frperror[0].TargetObject
    }

    return $FileName
}
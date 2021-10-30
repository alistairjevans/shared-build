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
        [string]
        $Version = "Latest"
    )

    Write-Message "Installing .NET SDK version $Version"

    $callerPath = Split-Path $MyInvocation.PSCommandPath
    $installDir = Join-Path -Path $callerPath -ChildPath ".dotnet/cli"
    if (!(Test-Path $installDir)) {
        New-Item -ItemType Directory -Path "$installDir" | Out-Null
    }

    # Download the dotnet CLI install script
    if ($IsWindows) {
        if (!(Test-Path ./.dotnet/dotnet-install.ps1)) {
            Invoke-WebRequest "https://dot.net/v1/dotnet-install.ps1" -OutFile "./.dotnet/dotnet-install.ps1"
        }

        & ./.dotnet/dotnet-install.ps1 -InstallDir "$installDir" -Version $Version
    } else {
        if (!(Test-Path ./.dotnet/dotnet-install.sh)) {
            Invoke-WebRequest "https://dot.net/v1/dotnet-install.sh" -OutFile "./.dotnet/dotnet-install.sh"
        }

        & bash ./.dotnet/dotnet-install.sh --install-dir "$installDir" --version $Version
    }

    Add-Path "$installDir"
}

<#
.SYNOPSIS
    Appends a given value to the path but only if the value does not yet exist within the path.
.PARAMETER Path
    The path to append.
#>
function Add-Path {
    [CmdletBinding()]
    Param(
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
    )
    
    $pathSeparator = ":";

    if ($IsWindows) {
        $pathSeparator = ";";
    }

    $pathValues = $env:PATH.Split($pathSeparator);
    if ($pathValues -Contains $Path) {
      return;
    }

    $env:PATH = "${Path}${pathSeparator}$env:PATH"
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

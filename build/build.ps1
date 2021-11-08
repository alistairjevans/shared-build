[CmdletBinding()]
param (
    [Parameter()]
    $ctxt
)

Import-Module $PSScriptRoot/Autofac.Build.psd1 -Force

# Build, then Pack
Write-Output $ctxt
Import-Module $PSScriptRoot/Autofac.Build.psd1 -Force

Write-Output $env:AUTOFAC_CTXT;

$ctxt = ConvertFrom-Json $env:AUTOFAC_CTXT;

# Build, then Pack
Write-Output $ctxt
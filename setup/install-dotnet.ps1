Import-Module $PSScriptRoot/Autofac.Setup.psd1 -Force

$globalJson = (Get-Content "global.json" | ConvertFrom-Json -NoEnumerate);

$sdkVersion = $globalJson.sdk.version

New-Item -ItemType Directory -Path "./.dotnet" | Out-Null

$installDir = Resolve-Path "./.dotnet";

"Installing to $installDir"

# Install dotnet CLI
Install-DotNetCli -InstallDir $installDir -Version $sdkVersion

foreach ($additional in $globalJson.additionalSdks)
{
    Install-DotNetCli -InstallDir $installDir -Version $additional;
}

# Add to system path
"$installDir" >> $env:GITHUB_PATH
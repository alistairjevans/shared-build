Import-Module $PSScriptRoot/Autofac.Setup.psd1 -Force

$globalJson = (Get-Content "global.json" | ConvertFrom-Json -NoEnumerate);

$sdkVersion = $globalJson.sdk.version

New-Item -ItemType Directory -Path "./.dotnet" | Out-Null

$fullDotNetPath = Resolve-Path "./.dotnet";
$cliPath = Join-Path $fullDotNetPath "cli"

# Install dotnet CLI
Install-DotNetCli -InstallDir $cliPath -Version $sdkVersion

foreach ($additional in $globalJson.additionalSdks)
{
    Install-DotNetCli -InstallDir $cliPath -Version $additional;
}

# Add to system path
"$cliPath" >> $env:GITHUB_PATH
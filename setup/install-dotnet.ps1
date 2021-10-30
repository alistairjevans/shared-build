Import-Module $PSScriptRoot/Autofac.Setup.psd1 -Force

$globalJson = (Get-Content "global.json" | ConvertFrom-Json -NoEnumerate);

$sdkVersion = $globalJson.sdk.version

$fullDotNetPath = Resolve-Path "./.dotnet";
$cliPath = Join-Path $fullDotNetPath "cli"

New-Item -ItemType Directory -Path $fullDotNetPath | Out-Null

# Install dotnet CLI
Install-DotNetCli -InstallDir $cliPath -Version $sdkVersion

foreach ($additional in $globalJson.additionalSdks)
{
    Install-DotNetCli -InstallDir $cliPath -Version $additional;
}

# Add to system path
"$cliPath" >> $env:GITHUB_PATH
Import-Module $PSScriptRoot/Autofac.Setup.psd1 -Force

$workingDir = $env:GITHUB_WORKSPACE;

Write-Message "Running in $workingDir"

$globalJson = (Get-Content "$workingDir/global.json" | ConvertFrom-Json -NoEnumerate);

$sdkVersion = $globalJson.sdk.version

# Install dotnet CLI
Write-Message "Installing .NET SDK version $sdkVersion"
Install-DotNetCli -Version $sdkVersion

foreach ($additional in $globalJson.additionalSdks)
{
    Install-DotNetCli -Version $additional;
}
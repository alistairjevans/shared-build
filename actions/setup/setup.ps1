Import-Module $PSScriptRoot/build/Autofac.Build.psd1 -Force

$workingDir = Get-Location;
$globalJson = (Get-Content "$workingDir/global.json" | ConvertFrom-Json -NoEnumerate);

$sdkVersion = $globalJson.sdk.version

# Clean up artifacts folder
if (Test-Path $artifactsPath) {
    Write-Message "Cleaning $artifactsPath folder"
    Remove-Item $artifactsPath -Force -Recurse
}

# Install dotnet CLI
Write-Message "Installing .NET SDK version $sdkVersion"
Install-DotNetCli -Version $sdkVersion

foreach ($additional in $globalJson.additionalSdks)
{
    Install-DotNetCli -Version $additional;
}
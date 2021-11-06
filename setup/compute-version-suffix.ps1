# Set version suffix
$branch = "";

if ($env:GITHUB_EVENT_NAME -eq "pull_request")
{
    # In a PR, use the branch name 'pr'
    $branch = "pr";
}
else 
{
    $branch = $($env:GITHUB_REF -split '/') | Select-Object -Last 1
}

$revision = @{ $true = "{0:00000}" -f [convert]::ToInt32("0" + $env:GITHUB_RUN_NUMBER, 10); $false = "local" }[$NULL -ne $env:GITHUB_RUN_NUMBER];
$versionSuffix = @{ $true = ""; $false = "-$($branch.Substring(0, [math]::Min(10,$branch.Length)).Replace('/', '-'))-$revision" }[$branch -eq "master" -and $revision -ne "local"]

Write-Output "::set-output name=version-suffix::$versionSuffix"
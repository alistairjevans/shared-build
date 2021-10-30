# Set version suffix
$branch = @{ $true = $env:GITHUB_REF; $false = $(git symbolic-ref --short -q HEAD) }[$NULL -ne $env:GITHUB_REF];
$revision = @{ $true = "{0:00000}" -f [convert]::ToInt32("0" + $env:GITHUB_RUN_NUMBER, 10); $false = "local" }[$NULL -ne $env:GITHUB_RUN_NUMBER];
$versionSuffix = @{ $true = ""; $false = "$($branch.Substring(0, [math]::Min(10,$branch.Length)).Replace('/', '-'))-$revision" }[$branch -eq "master" -and $revision -ne "local"]

"::set-output name=versionSuffix::$versionSuffix"
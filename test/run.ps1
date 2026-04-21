param(
    [string]$RootDir = "build"
)

$ErrorActionPreference = "Stop"

bash "$PSScriptRoot/run.sh" $RootDir
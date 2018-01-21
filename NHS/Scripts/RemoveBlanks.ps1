param ([string]$FilePath)
$Files = Get-ChildItem *.csv -Path $FilePath| Rename-Item -NewName { $_.Name -replace ' ','+'}


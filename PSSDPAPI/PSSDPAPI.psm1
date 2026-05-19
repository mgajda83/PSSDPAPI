Get-ChildItem -Path $PSScriptRoot -Recurse | Unblock-File
Get-ChildItem -Path $PSScriptRoot\*.ps1 -Recurse | Foreach-Object{ . $_.FullName }

Export-ModuleMember -Cmdlet * -Alias * -Function *
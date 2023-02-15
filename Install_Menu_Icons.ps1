# Getting profile name
$String = (Get-Content -Path "$env:APPDATA\Mozilla\Firefox\installs.ini" | Select-String -Pattern "^\s*Default\s*=\s*.+" | ConvertFrom-StringData).Default
$ProfileName = Split-Path -Path $String -Leaf

$Parameters = @{
    Uri             = "https://github.com/farag2/Mozilla-Firefox/raw/master/Icons.zip"
    OutFile         = "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\Icons.zip"
    UseBasicParsing = $true
    Verbose         = $true
}
Invoke-WebRequest @Parameters

$Parameters = @{
	Path            = "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\Icons.zip"
	DestinationPath = "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName"
	Force           = $true
	Verbose         = $true
}
Expand-Archive @Parameters

Remove-Item -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\Icons.zip" -Force

Write-Verbose -Message "userChrome.RegularMenuIcons-Enabled" -Verbose

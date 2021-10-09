Get-Process -Name firefox -ErrorAction Ignore | Stop-Process -Force
Start-Sleep -Seconds 1

#region Toolbar
# Getting profile name
$String = (Get-Content -Path "$env:APPDATA\Mozilla\Firefox\installs.ini" | Select-String -Pattern "^\s*Default\s*=\s*.+" | ConvertFrom-StringData).Default
$ProfileName = Split-Path -Path $String -Leaf

# Finding where the Toolbar settings store are
[string]$String = Get-Content -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\prefs.js" | Select-String -Pattern '"browser\.uiCustomization\.state"'

# Deleting all "\" in the string
$String2 = $String.Replace("\", "")

# Deleting the first 44 characters to delete 'user_pref("browser.uiCustomization.state", "'
$Substring = $String2.Substring(44)

# Deleting the last 3 characters to delete '");'
[Object]$QuickJson = $Substring.Substring(0,$Substring.Length-3)

[Object]$JSON = ConvertFrom-Json -InputObject $QuickJson

# The necessary buttons sequence
$NavBar = (
	# Back
	"back-button",

	# Forward
	"forward-button",

	# Address bar
	"urlbar-container",

	# Home
	"home-button",

	# Reload
	"stop-reload-button",

	# Bookmarks menu
	"bookmarks-menu-button",

	# Show your bookmarks
	"downloads-button",

	# Firefox Account
	"fxa-toolbar-menu-button"
)
$JSON.placements.'nav-bar' = $NavBar
$ConfiguredJSON = $JSON | ConvertTo-Json -Depth 10

# Replacing all '"' with '\"', as it was
$ConfiguredString = $ConfiguredJSON.Replace('"', '\"').ToString()

# Replacing the entire string with the result
$prefsjs = "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\prefs.js"
$Replace = "user_pref(`"browser.uiCustomization.state`", `"$ConfiguredString`");"
(Get-Content -Path $prefsjs).Replace($String, $Replace) | Set-Content -Path $prefsjs -Force
#endregion Toolbar

# Turn off all scheduled tasks in Mozilla folder
Get-ScheduledTask -TaskPath "\Mozilla\" -ErrorAction Ignore | Disable-ScheduledTask

#region Download
# Download search.json.mozlz4
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Parameters = @{
	Uri             = "https://github.com/farag2/Mozilla-Firefox/raw/master/search.json.mozlz4"
	OutFile         = "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\search.json.mozlz4"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

# Download user.js
$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Mozilla-Firefox/master/user.js"
	OutFile         = "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\user.js"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters
Start-Process -FilePath $env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName

# Download userChrome.css
if (-not (Test-Path -Path $env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\chrome))
{
	New-Item -Path $env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\chrome -ItemType Directory -Force
}
$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Mozilla-Firefox/master/chrome/userChrome.css"
	OutFile         = "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\chrome\userChrome.css"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters
#endregion Download

# Install extensions
# https://addons.mozilla.org/firefox/addon/ublock-origin/
# https://addons.mozilla.org/firefox/addon/traduzir-paginas-web/
# https://addons.mozilla.org/firefox/addon/tampermonkey/
# https://addons.mozilla.org/firefox/addon/sponsorblock/
# https://github.com/farag2/Mozilla-Firefox/blob/master/Add_Firefox_Extensions.ps1
$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Mozilla-Firefox/master/Add_Firefox_Extensions.ps1"
	OutFile         = "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\chrome\userChrome.css"
	UseBasicParsing = $true
}
Invoke-RestMethod @Parameters | Invoke-Expression

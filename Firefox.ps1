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
	Uri = "https://github.com/farag2/Mozilla-Firefox/raw/master/search.json.mozlz4"
	OutFile = "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\search.json.mozlz4"
	Verbose = [switch]::Present
}
Invoke-WebRequest @Parameters

# Download user.js
$Parameters = @{
	Uri = "https://raw.githubusercontent.com/farag2/Mozilla-Firefox/master/user.js"
	OutFile = "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\user.js"
	Verbose = [switch]::Present
}
Invoke-WebRequest @Parameters
Start-Process -FilePath $env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName

# Download userChrome.css
if (-not (Test-Path -Path $env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\chrome))
{
	New-Item -Path $env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\chrome -ItemType Directory -Force
}
$Parameters = @{
	Uri = "https://raw.githubusercontent.com/farag2/Mozilla-Firefox/master/chrome/userChrome.css"
	OutFile = "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\chrome\userChrome.css"
	Verbose = [switch]::Present
}
Invoke-WebRequest @Parameters
#endregion Download

# Check if extensions installed
$Extensions = @{
	# uBlock Origin
	"$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions\uBlock0@raymondhill.net.xpi" = "https://addons.mozilla.org/firefox/addon/ublock-origin/"

	# Translate Web Pages
	"$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions\{036a55b4-5e72-4d05-a06c-cba2dfcc134a}.xpi" = "https://addons.mozilla.org/firefox/addon/traduzir-paginas-web/"

	# Tampermonkey
	"$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions\firefox@tampermonkey.net.xpi" = @(
		"https://addons.mozilla.org/firefox/addon/tampermonkey/",
		"https://greasyfork.org/ru/scripts/19993-ru-adlist-js-fixes",
		"https://serguun42.ru/tampermonkey/osnova_dark_theme.user.js"
	)

	# Country Flags & IP Whois
	"$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions\{802a552e-13d1-4683-a40a-1e5325fba4bb}.xpi" = "https://addons.mozilla.org/ru/firefox/addon/server-ip/"

	# SponsorBlock
	"$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions\sponsorBlocker@ajay.app.xpi" = "https://addons.mozilla.org/firefox/addon/sponsorblock/"
}
foreach ($Extension in $Extensions.Keys)
{
	if (-not (Test-Path -Path $Extension))
	{
		# Open its' page
		Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -ArgumentList "-new-tab $($Extensions[$Extension])"
	}
}

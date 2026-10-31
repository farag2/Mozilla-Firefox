#Requires -RunAsAdministrator

[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

if ($Host.Version.Major -eq 5)
{
	# Progress bar can significantly impact cmdlet performance
	# https://github.com/PowerShell/PowerShell/issues/2138
	$Script:ProgressPreference = "SilentlyContinue"
}

if (-not (Test-Path -Path "$env:APPDATA\Mozilla\Firefox\installs.ini"))
{
	Write-Warning -Message "Please launch Firefox first."
	return
}

# Close Firefox gracefully so it flushes prefs.js and the session, then kill whatever is left
$Processes = Get-Process -Name firefox -ErrorAction Ignore
if ($Processes)
{
	$null = $Processes.CloseMainWindow()
	$Processes | Wait-Process -Timeout 10 -ErrorAction Ignore
	Get-Process -Name firefox -ErrorAction Ignore | Stop-Process -Force -PassThru | Wait-Process -ErrorAction Ignore
}

#region Profile
# installs.ini may contain several installs (Release, ESR, Nightly). [308046B0AF4A39CB] is "C:\Program Files\Mozilla Firefox"
$Section = $null
$Defaults = [ordered]@{}
foreach ($Line in (Get-Content -Path "$env:APPDATA\Mozilla\Firefox\installs.ini" -Encoding UTF8))
{
	$Line = $Line.Trim()
	if ($Line.StartsWith("["))
	{
		$Section = $Line.Trim("[", "]")
	}
	elseif ($Line.StartsWith("Default="))
	{
		$Defaults[$Section] = $Line.Substring(8)
	}
}

if ($Defaults.Contains("308046B0AF4A39CB"))
{
	$Default = $Defaults["308046B0AF4A39CB"]
}
else
{
	$Default = @($Defaults.Values)[0]
}

# The path is relative to %APPDATA%\Mozilla\Firefox unless the profile was created in a custom folder
if (Split-Path -Path $Default -IsAbsolute)
{
	$ProfilePath = (Get-Item -Path $Default).FullName
}
else
{
	$ProfilePath = (Get-Item -Path "$env:APPDATA\Mozilla\Firefox\$Default").FullName
}
#endregion Profile

#region Download
# https://github.com/farag2/Mozilla-Firefox/blob/master/search.json.mozlz4
$Parameters = @{
	Uri             = "https://github.com/farag2/Mozilla-Firefox/raw/master/search.json.mozlz4"
	OutFile         = "$ProfilePath\search.json.mozlz4"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

# https://github.com/farag2/Mozilla-Firefox/blob/master/user.js
$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Mozilla-Firefox/master/user.js"
	OutFile         = "$ProfilePath\user.js"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

if (-not (Test-Path -Path "$ProfilePath\chrome"))
{
	New-Item -Path "$ProfilePath\chrome" -ItemType Directory -Force
}

# https://github.com/farag2/Mozilla-Firefox/blob/master/chrome/userChrome.css
$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Mozilla-Firefox/master/chrome/userChrome.css"
	OutFile         = "$ProfilePath\chrome\userChrome.css"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters
#endregion Download

#region Toolbar
# Toolbar buttons sequence. Add your extensions icons here
$NavBar = @(
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

	# Downloads
	"downloads-button",

	# Firefox VPN
	"ipprotection-button",

	# Firefox Account
	"fxa-toolbar-menu-button",

	# uBlock Origin
	"ublock0_raymondhill_net-browser-action"
)

$Prefix = 'user_pref("browser.uiCustomization.state", '
$State = Get-Content -Path "$ProfilePath\prefs.js" -Encoding UTF8 | Where-Object -FilterScript {$_.StartsWith($Prefix)} | Select-Object -First 1

if ($State)
{
	# The pref value is a JS string literal, which is also a valid JSON string literal: decode it to a string, then to an object
	$JSON = $State.Substring($Prefix.Length).TrimEnd(";", ")") | ConvertFrom-Json | ConvertFrom-Json

	$JSON.placements.'nav-bar' = $NavBar

	# Remove these buttons and Firefox View from all other areas so that nothing is placed twice
	foreach ($Area in @($JSON.placements.PSObject.Properties.Name))
	{
		if ($Area -ne "nav-bar")
		{
			$JSON.placements.$Area = @($JSON.placements.$Area | Where-Object -FilterScript {($_ -notin $NavBar) -and ($_ -ne "firefox-view-button")})
		}
	}

	# Pass the pref via user.js instead of rewriting prefs.js: Firefox applies it on the next start and saves it to prefs.js itself
	$Value = $JSON | ConvertTo-Json -Depth 10 -Compress | ConvertTo-Json -Compress
	[System.IO.File]::AppendAllText("$ProfilePath\user.js", "`n$Prefix$Value);`n", [System.Text.UTF8Encoding]::new($false))
}
else
{
	Write-Warning -Message "browser.uiCustomization.state not found in prefs.js. Toolbar was not configured."
}
#endregion Toolbar

# Turn off all scheduled tasks in Mozilla folder
Get-ScheduledTask -TaskPath "\Mozilla\" -ErrorAction Ignore | Disable-ScheduledTask

#region Search engine
# tapochek.net supports windows-1251 encoding only. Cannot be added via UI
# Firefox reads policies at startup, so they have to be set before launch
# https://firefox-admin-docs.mozilla.org/reference/policies/searchengines/
if (-not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Mozilla\Firefox\SearchEngines\Add\1"))
{
	New-Item -Path "HKLM:\SOFTWARE\Policies\Mozilla\Firefox\SearchEngines\Add\1" -Force
}

$Engine = [ordered]@{
	Name        = "Tapochek"
	URLTemplate = "https://tapochek.net/tracker.php?nm={searchTerms}"
	Method      = "GET"
	Encoding    = "windows-1251"
	Alias       = "@tp"
	IconURL     = "https://tapochek.net/favicon.ico"
}
foreach ($Property in $Engine.GetEnumerator())
{
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Mozilla\Firefox\SearchEngines\Add\1" -Name $Property.Key -PropertyType String -Value $Property.Value -Force
}
#endregion Search engine

# Install extensions and launch Firefox with about:addons
# https://github.com/farag2/Mozilla-Firefox/blob/master/Add_Firefox_Extensions.ps1
$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Mozilla-Firefox/master/Add_Firefox_Extensions.ps1"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-RestMethod @Parameters | Invoke-Expression

# Wait for the browser window (up to 60 s): by then Firefox has already read user.js
for ($i = 0; $i -lt 120; $i++)
{
	if (Get-Process -Name firefox -ErrorAction Ignore | Where-Object -FilterScript {$_.MainWindowHandle -ne 0})
	{
		break
	}

	Start-Sleep -Milliseconds 500
}

Remove-Item -Path "$ProfilePath\user.js" -Force
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

# Close Firefox gracefully, then kill whatever is left
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
$ProfileName = Split-Path -Path $Default -Leaf
#endregion Profile

if (-not (Test-Path -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions"))
{
	New-Item -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions" -ItemType Directory -Force
}

$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
if (-not (Test-Path -Path "$DownloadsFolder\Extensions"))
{
	New-Item -Path "$DownloadsFolder\Extensions" -ItemType Directory -Force
}

function Add-FirefoxExtension
{
	param
	(
		[string[]]
		$URLs
	)

	foreach ($URL in $URLs)
	{
		$ExtensionName = Split-Path -Path $URL -Leaf

		# https://mozilla.github.io/addons-server/topics/api/addons.html#get--api-v5-addons-addon-(int-id|string-slug|string-guid)-
		$Parameters = @{
			Uri             = "https://addons.mozilla.org/api/v5/addons/addon/$ExtensionName/"
			Headers         = @{"User-Agent" = "Mozilla/5.0"}
			UseBasicParsing = $true
			Verbose         = $true
		}
		$Response = Invoke-RestMethod @Parameters

		# guid is the extension ID from manifest.json, which Firefox expects as the file name
		$Parameters = @{
			Uri             = $Response.current_version.file.url
			Headers         = @{"User-Agent" = "Mozilla/5.0"}
			OutFile         = "$DownloadsFolder\Extensions\$($Response.guid).xpi"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		Move-Item -Path "$DownloadsFolder\Extensions\$($Response.guid).xpi" -Destination "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions\$($Response.guid).xpi" -Force
	}
}

$URLs = @(
	"https://addons.mozilla.org/firefox/addon/ublock-origin",
	"https://addons.mozilla.org/firefox/addon/traduzir-paginas-web",
	"https://addons.mozilla.org/firefox/addon/sponsorblock",
	"https://addons.mozilla.org/firefox/addon/return-youtube-dislikes",
	"https://addons.mozilla.org/ru/firefox/addon/reyohoho-twitch-proxy"
)
Add-FirefoxExtension -URLs $URLs

# https://gitflic.ru/project/magnolia1234/bpc_uploads
$Parameters = @{
	Uri             = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass_paywalls_clean-latest.xpi"
	OutFile         = "$DownloadsFolder\Extensions\bpc.xpi"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

& "$env:SystemRoot\System32\tar.exe" -xvf "$DownloadsFolder\Extensions\bpc.xpi" -C "$DownloadsFolder\Extensions" manifest.json

# Get the author id
$Manifest = Get-Content -Path "$DownloadsFolder\Extensions\manifest.json" -Encoding UTF8 -Raw | ConvertFrom-Json
if ($Manifest.browser_specific_settings.gecko.id)
{
	Move-Item -Path "$DownloadsFolder\Extensions\bpc.xpi" -Destination "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions\$($Manifest.browser_specific_settings.gecko.id).xpi" -Force
}
else
{
	Write-Warning -Message "No ID found in Bypass Paywalls Clean manifest.json."
}

Remove-Item -Path "$DownloadsFolder\Extensions" -Recurse -Force

Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -ArgumentList "-new-tab about:addons"

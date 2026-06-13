function Add-FirefoxExtension
{
	param
	(
		[string[]]
		$URLs
	)

	if (-not (Test-Path -Path "$env:APPDATA\Mozilla\Firefox\installs.ini"))
	{
		Write-Warning -Message "Please launch Firefox first."
		exit
	}

	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

	if ($Host.Version.Major -eq 5)
	{
		# Progress bar can significantly impact cmdlet performance
		# https://github.com/PowerShell/PowerShell/issues/2138
		$Script:ProgressPreference = "SilentlyContinue"
	}

	if (Get-Process -Name firefox -ErrorAction Ignore)
	{
		(Get-Process -Name firefox).CloseMainWindow()
	}

	$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
	if (-not (Test-Path -Path "$DownloadsFolder\Extensions"))
	{
		New-Item -Path "$DownloadsFolder\Extensions" -ItemType Directory -Force
	}

	# Get Firefox profile name
	$String = (Get-Content -Path "$env:APPDATA\Mozilla\Firefox\installs.ini" -Encoding Default | Select-String -Pattern "^\s*Default\s*=\s*.+" | ConvertFrom-StringData).Default
	$ProfileName = Split-Path -Path $String -Leaf

	foreach ($URL in $URLs)
	{
		$ExtensionName = Split-Path -Path $URL -Leaf

		# https://mozilla.github.io/addons-server/topics/api/addons.html#get--api-v5-addons-addon-(int-id|string-slug|string-guid)-
		$Parameters = @{
			Uri             = "https://addons.mozilla.org/api/v5/addons/addon/$ExtensionName"
			Headers         = @{"User-Agent" = "Mozilla/5.0"}
			UseBasicParsing = $true
			Verbose         = $true
		}
		$Response = Invoke-RestMethod @Parameters

		$XPI = Split-Path -Path $Response.current_version.file.url -Leaf

		$Parameters = @{
			Uri             = $Response.current_version.file.url
			Headers         = @{"User-Agent" = "Mozilla/5.0"}
			OutFile         = "$DownloadsFolder\Extensions\$XPI"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		& "$env:SystemRoot\System32\tar.exe" -xvf "$DownloadsFolder\Extensions\$XPI" -C "$DownloadsFolder\Extensions" manifest.json

		# Get the author id
		$manifest = Get-Content -Path "$DownloadsFolder\Extensions\manifest.json" -Encoding Default -Force | ConvertFrom-Json
		if ($manifest.applications.gecko.id)
		{
			$ApplicationID = $manifest.applications.gecko.id
		}
		elseif ($manifest.browser_specific_settings.gecko.id)
		{
			$ApplicationID = $manifest.browser_specific_settings.gecko.id
		}
		else
		{
			Write-Warning -Message "No ID found in manifest.json for $URL."
			exit
		}

		Rename-Item -Path "$DownloadsFolder\Extensions\$XPI" -NewName "$ApplicationID.xpi" -Force

		if (-not (Test-Path -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions"))
		{
			New-Item -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions" -ItemType Directory -Force
		}

		Copy-Item -Path "$DownloadsFolder\Extensions\$ApplicationID.xpi" -Destination "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions" -Force
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

$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
if (-not (Test-Path -Path "$DownloadsFolder\Extensions"))
{
	New-Item -Path "$DownloadsFolder\Extensions" -ItemType Directory -Force
}

# https://gitflic.ru/project/magnolia1234/bpc_uploads
$Parameters = @{
	Uri             = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass_paywalls_clean-latest.xpi"
	Outfile         = "$DownloadsFolder\Extensions\bpc.xpi"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-RestMethod @Parameters

& "$env:SystemRoot\System32\tar.exe" -xvf "$DownloadsFolder\Extensions\bpc.xpi" -C "$DownloadsFolder\Extensions" manifest.json

# Get the author id
$manifest = Get-Content -Path "$DownloadsFolder\Extensions\manifest.json" -Encoding Default -Force | ConvertFrom-Json
$ApplicationID = $manifest.browser_specific_settings.gecko.id

Rename-Item -Path "$DownloadsFolder\Extensions\bpc.xpi" -NewName "$ApplicationID.xpi" -Force

if (-not (Test-Path -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions"))
{
	New-Item -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions" -ItemType Directory -Force
}

Copy-Item -Path "$DownloadsFolder\Extensions\$ApplicationID.xpi" -Destination "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions" -Force

Remove-Item -Path "$DownloadsFolder\Extensions" -Recurse -Force

Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -ArgumentList "-new-tab about:addons"

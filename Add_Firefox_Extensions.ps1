<#
	.SYNOPSIS
	Add extensions to Firefox automatically

	.PARAMETER ExtensionUri
	Copy URL on an extesion page by right-clicking on the Download button

	.EXAMPLE
	$Parameters = @{
		ExtensionUris = @("https://addons.mozilla.org/firefox/addon/ublock-origin")
	}
	Add-FirefoxExtension @Parameters

	.NOTES
	If an extension doesn't have a valid manifets.json you have to find out the ID by yourself
	Example: https://github.com/farag2/Mozilla-Firefox/discussions/1#discussioncomment-1218530

	.NOTES
	Enable extension manually
#>
function Add-FirefoxExtension
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[string[]]
		$ExtensionUris
	)

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

	foreach ($Uri in $ExtensionUris)
	{
		# Downloading extension
		$Parameters = @{
			Uri             = $Uri
			UseBasicParsing = $false # Disabled
			Verbose         = $true
		}
		$Request = Invoke-Webrequest @Parameters
		$URL = $Request.ParsedHtml.getElementsByClassName("InstallButtonWrapper-download-link") | ForEach-Object -Process {$_.href}

		$Extension = Split-Path -Path $URL -Leaf

		$Parameters = @{
			Uri              = $URL
			OutFile          = "$DownloadsFolder\Extensions\$Extension"
			UseBasicParsing  = $true
			Verbose          = $true
		}
		Invoke-WebRequest @Parameters

		# Copy file and rename it into .zip
		Get-Item -Path "$DownloadsFolder\Extensions\$Extension" -Force | Foreach-Object -Process {
			Copy-Item -Path $_.FullName -Destination "$($_.BaseName).zip" -Force
		}

		<#
			.SYNOPSIS
			Expand the specific file from ZIP archive. Folder structure will be created recursively

			.Parameter Source
			The source ZIP archive

			.Parameter Destination
			Where to expand file

			.Parameter File
			Assign the file to expand

			.Example
			ExtractZIPFile -Source "D:\Folder\File.zip" -Destination "D:\Folder" -File "Folder1/Folder2/File.txt"
		#>
		function ExtractZIPFile
		{
			[CmdletBinding()]
			param
			(
				[string]
				$Source,

				[string]
				$Destination,

				[string]
				$File
			)

			Add-Type -Assembly System.IO.Compression.FileSystem

			$ZIP = [IO.Compression.ZipFile]::OpenRead($Source)
			$Entries = $ZIP.Entries | Where-Object -FilterScript {$_.FullName -eq $File}

			$Destination = "$Destination\$(Split-Path -Path $File -Parent)"

			if (-not (Test-Path -Path $Destination))
			{
				New-Item -Path $Destination -ItemType Directory -Force
			}

			$Entries | ForEach-Object -Process {[IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$($Destination)\$($_.Name)", $true)}

			$ZIP.Dispose()
		}

		$Parameters = @{
			Source      = "$DownloadsFolder\Extensions\$Extension"
			Destination = "$DownloadsFolder\Extensions"
			File        = "manifest.json"
		}
		ExtractZIPFile @Parameters

		# Get the author id
		$manifest = Get-Content -Path "$DownloadsFolder\Extensions\manifest.json" -Encoding Default -Force | ConvertFrom-Json
		# Some extensions don't have valid JSON manifest
		if ($null -ne $manifest.applications)
		{
			$ApplicationID = $manifest.applications.gecko.id
		}
		else
		{
			$ApplicationID = $manifest.browser_specific_settings.gecko.id
		}

		if (-not (Test-Path -Path "$DownloadsFolder\Extensions\$ApplicationID.xpi"))
		{
			Rename-Item -Path "$DownloadsFolder\Extensions\$Extension" -NewName "$ApplicationID.xpi" -Force
		}

		# Getting Firefox profile name
		$String = (Get-Content -Path "$env:APPDATA\Mozilla\Firefox\installs.ini" -Encoding Default | Select-String -Pattern "^\s*Default\s*=\s*.+" | ConvertFrom-StringData).Default
		$ProfileName = Split-Path -Path $String -Leaf

		if (-not (Test-Path -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions"))
		{
			New-Item -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions" -ItemType Directory -Force
		}

		# Copy .xpi extension file to the extensions folder
		if (-not (Test-Path -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions\$ApplicationID.xpi"))
		{
			Copy-Item -Path "$DownloadsFolder\Extensions\$ApplicationID.xpi" -Destination "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions" -Force
		}
	}

	Remove-Item -Path "$DownloadsFolder\Extensions" -Recurse -Force -ErrorAction Ignore
}

$Parameters = @{
	ExtensionUris = @(
		"https://addons.mozilla.org/firefox/addon/ublock-origin",
		"https://addons.mozilla.org/firefox/addon/traduzir-paginas-web",
		"https://addons.mozilla.org/firefox/addon/tampermonkey",
		"https://addons.mozilla.org/firefox/addon/sponsorblock",
		"https://addons.mozilla.org/firefox/addon/return-youtube-dislikes"
	)
}
Add-FirefoxExtension @Parameters

$Parameters = @{
	Uri             = "https://gitlab.com/magnolia1234/bpc-uploads/-/raw/master/bypass_paywalls_clean-latest.xpi?ref_type=heads&inline=false"
	OutFile         = "$DownloadsFolder\Extensions\bypass-paywalls-firefox-clean.zip"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters
#>

$Parameters = @{
	Path            = "$DownloadsFolder\Extensions\bypass-paywalls-firefox-clean.zip"
	DestinationPath = "$DownloadsFolder\Extensions"
	Force           = $true
}
Expand-Archive @Parameters

# Get latest archive version
$Parameters = @{
	Uri             = "https://gitlab.com/api/v4/projects/$id/releases/permalink/latest"
	UseBasicParsing = $true
	Verbose         = $true
}
$tag_name = (Invoke-RestMethod @Parameters).tag_name

# Get the author id
$Parameters = @{
	Uri             = "https://gitlab.com/magnolia1234/bypass-paywalls-firefox-clean/-/raw/master/manifest.json?ref_type=heads"
	UseBasicParsing = $true
	Verbose         = $true
}
$ApplicationID = (Invoke-RestMethod @Parameters).browser_specific_settings.gecko.id

if (-not (Test-Path -Path "$DownloadsFolder\Extensions\$ApplicationID.xpi"))
{
	Rename-Item -Path "$DownloadsFolder\Extensions\bypass-paywalls-firefox-clean.zip" -NewName "$ApplicationID.xpi" -Force
}

# Getting Firefox profile name
$String = (Get-Content -Path "$env:APPDATA\Mozilla\Firefox\installs.ini" -Encoding Default | Select-String -Pattern "^\s*Default\s*=\s*.+" | ConvertFrom-StringData).Default
$ProfileName = Split-Path -Path $String -Leaf

if (-not (Test-Path -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions"))
{
	New-Item -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions" -ItemType Directory -Force
}

# Copy .xpi extension file to the extensions folder
if (-not (Test-Path -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions\$ApplicationID.xpi"))
{
	Copy-Item -Path "$DownloadsFolder\Extensions\$ApplicationID.xpi" -Destination "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions" -Force
}

Remove-Item -Path "$DownloadsFolder\Extensions" -Recurse -Force -ErrorAction Ignore

Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -ArgumentList "-new-tab about:addons"

# Install additional JS scripts for Tampermonkey
# We need to open Firefox process first to be able to open new tabs. Unless every new tab will be opened in a new process
if (Test-Path -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions\firefox@tampermonkey.net.xpi")
{
	Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -ArgumentList "-new-tab `"https://greasyfork.org/scripts/19993-ru-adlist-js-fixes/code/RU%20AdList%20JS%20Fixes.user.js`""
}

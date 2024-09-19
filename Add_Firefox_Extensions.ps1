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

<#
	.SYNOPSIS
	Install extensions to Firefox automatically

	.EXAMPLE
	$Parameters = @{
		"https://addons.mozilla.org/firefox/addon/ublock-origin" = "$env:APPDATA\Mozilla\Firefox\Profiles\ProfileName\extensions\uBlock0@raymondhill.net.xpi"
	}
	Add-FirefoxExtension @Parameters

	.NOTES
	If an extension doesn't have a valid manifets.json you have to find out the ID by yourself
	Example: https://github.com/farag2/Mozilla-Firefox/discussions/1#discussioncomment-1218530

	.NOTES
	Leave "ProfileName" in extention installation path as it is

	.NOTES
	Enable extension manually
#>
function Add-FirefoxExtension
{
	if (-not (Test-Path -Path "$env:APPDATA\Mozilla\Firefox\installs.ini"))
	{
		Write-Warning -Message "Please launch Firefox first"
		exit
	}

	# Get Firefox profile name
	$String = (Get-Content -Path "$env:APPDATA\Mozilla\Firefox\installs.ini" -Encoding Default | Select-String -Pattern "^\s*Default\s*=\s*.+" | ConvertFrom-StringData).Default
	$ProfileName = Split-Path -Path $String -Leaf

	# Parse $Parameters hashtable
	$Parameters.GetEnumerator() | ForEach-Object -Process {
		# Replace "ProfileName" with real profile name
		if (-not (Test-Path -Path $_.Value.Replace("ProfileName", "$ProfileName")))
		{
			# Downloading extension
			$Parameters = @{
				Uri             = $_.Name
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
				Copy-Item -Path $_.FullName -Destination "$DownloadsFolder\Extensions\$($_.BaseName).zip" -Force
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
			if ($manifest.applications.gecko.id)
			{
				$ApplicationID = $manifest.applications.gecko.id
			}
			elseif ($manifest.browser_specific_settings.gecko.id)
			{
				$ApplicationID = $manifest.browser_specific_settings.gecko.id
			}

			if (-not (Test-Path -Path "$DownloadsFolder\Extensions\$ApplicationID.xpi"))
			{
				Rename-Item -Path "$DownloadsFolder\Extensions\$Extension" -NewName "$ApplicationID.xpi" -Force
			}

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
	}
}

# Retrive extensions' ID to check path for
$Parameters = @{
	"https://addons.mozilla.org/firefox/addon/ublock-origin"           = "$env:APPDATA\Mozilla\Firefox\Profiles\ProfileName\extensions\uBlock0@raymondhill.net.xpi"
	"https://addons.mozilla.org/firefox/addon/traduzir-paginas-web"    = "$env:APPDATA\Mozilla\Firefox\Profiles\ProfileName\extensions\{036a55b4-5e72-4d05-a06c-cba2dfcc134a}.xpi"
	"https://addons.mozilla.org/firefox/addon/sponsorblock"            = "$env:APPDATA\Mozilla\Firefox\Profiles\ProfileName\extensions\sponsorBlocker@ajay.app.xpi"
	# https://greasyfork.org/ru/scripts/436115-return-youtube-dislike
	"https://addons.mozilla.org/firefox/addon/return-youtube-dislikes" = "$env:APPDATA\Mozilla\Firefox\Profiles\ProfileName\extensions\{762f9885-5a13-4abd-9c77-433dcd38b8fd}.xpi"
}
Add-FirefoxExtension @Parameters

# https://gitflic.ru/project/magnolia1234/bpc_uploads
# https://github.com/bpc-clone/bypass-paywalls-firefox-clean
$Parameters = @{
	Uri             = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass_paywalls_clean-latest.xpi"
	Outfile         = "$DownloadsFolder\Extensions\bpc.xpi"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-RestMethod @Parameters

# Copy file and rename it into .zip
Get-Item -Path "$DownloadsFolder\Extensions\bpc.xpi" -Force | Foreach-Object -Process {
	Copy-Item -Path $_.FullName -Destination "$DownloadsFolder\Extensions\$($_.BaseName).zip" -Force
}

$Parameters = @{
	Path            = "$DownloadsFolder\Extensions\bpc.zip"
	DestinationPath = "$DownloadsFolder\Extensions"
	Force           = $true
}
Expand-Archive @Parameters

# Get the author id
$manifest = Get-Content -Path "$DownloadsFolder\Extensions\manifest.json" -Encoding Default -Force | ConvertFrom-Json
$ApplicationID = $manifest.browser_specific_settings.gecko.id

if (-not (Test-Path -Path "$DownloadsFolder\Extensions\$ApplicationID.xpi"))
{
	Rename-Item -Path "$DownloadsFolder\Extensions\bpc.xpi" -NewName "$ApplicationID.xpi" -Force
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

Remove-Item -Path "$DownloadsFolder\Extensions" -Recurse -Force

Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -ArgumentList "-new-tab about:addons"

# Install additional RU AdList: Counters
# We need to open Firefox process first to be able to open new tabs. Unless every new tab will be opened in a new process
# https://github.com/easylist/ruadlist/wiki/RU-Adlist-links
# https://greasyfork.org/ru/scripts/19993-ru-adlist-js-fixes
if (Test-Path -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions\uBlock0@raymondhill.net.xpi") 
{
	Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -ArgumentList "-new-tab `"https://easylist-downloads.adblockplus.org/cntblock.txt`""
}

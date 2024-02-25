<#
	.SYNOPSIS
	Add extensions to Firefox automatically

	.PARAMETER ExtensionUri
	Copy URL on an extesion page by right-clicking on the Download button

	.PARAMETER Hive
	HKLM affects every user of a machine, HKCU will affect only the primary user

	.EXAMPLE
	$Parameters = @{
		ExtensionUris = @("https://addons.mozilla.org/firefox/addon/ublock-origin")
		Hive          = "HKCU"
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
		$ExtensionUris,

		[Parameter(Mandatory = $false)]
		[ValidateSet("HKCU", "HKLM")]
		[string]
		$Hive
	)

	$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
	if (-not (Test-Path -Path "$DownloadsFolder\Extensions"))
	{
		New-Item -Path "$DownloadsFolder\Extensions" -ItemType Directory -Force
	}

	# Skip Internet Explorer first run wizard to let script use Trident function to parse sites
	if (-not (Test-Path -Path "HKLM:\Software\Policies\Microsoft\Internet Explorer\Main"))
	{
		New-Item -Path "HKLM:\Software\Policies\Microsoft\Internet Explorer\Main" -ItemType Directory -Force
	}
	New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Internet Explorer\Main" -Name DisableFirstRunCustomize -PropertyType String -Value 1 -Force

	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

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
			$NewName = $_.FullName -replace ".xpi", ".zip"
			Copy-Item -Path $_.FullName -Destination $NewName -Force
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
		# https://github.com/farag2/Mozilla-Firefox/discussions/1#discussioncomment-1218530
		if ($null -ne $manifest.applications)
		{
			$ApplicationID = $manifest.applications.gecko.id
		}
		else
		{
			$ApplicationID = $manifest.browser_specific_settings.gecko.id
		}

		Get-Item -Path "$DownloadsFolder\Extensions\$Extension" -Force | Rename-Item -NewName "$ApplicationID.xpi" -Force

		# Getting Firefox profile name
		$String = (Get-Content -Path "$env:APPDATA\Mozilla\Firefox\installs.ini" -Encoding Default | Select-String -Pattern "^\s*Default\s*=\s*.+" | ConvertFrom-StringData).Default
		$ProfileName = Split-Path -Path $String -Leaf

		if (-not (Test-Path -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions"))
		{
			New-Item -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions" -ItemType Directory -Force
		}

		# Copy .xpi extension file to the extensions folder
		Copy-Item -Path "$DownloadsFolder\Extensions\$ApplicationID.xpi" -Destination "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions" -Force

		switch ($Hive)
		{
			"HKCU"
			{
				if (-not (Test-Path -Path HKCU:\Software\Mozilla\Firefox\Extensions))
				{
					New-Item -Path HKCU:\Software\Mozilla\Firefox\Extensions -Force
				}
				New-ItemProperty -Path HKCU:\Software\Mozilla\Firefox\Extensions -Name $ApplicationID -PropertyType String -Value "$DownloadsFolder\Extenstions\$ApplicationID.xpi" -Force
			}
			"HKLM"
			{
				if (-not (Test-Path -Path HKLM:\Software\Mozilla\Firefox\Extensions))
				{
					New-Item -Path HKLM:\Software\Mozilla\Firefox\Extensions -Force
				}
				New-ItemProperty -Path HKLM:\Software\Mozilla\Firefox\Extensions -Name $ApplicationID -PropertyType String -Value "$DownloadsFolder\Extenstions\$ApplicationID.xpi" -Force
			}
		}
	}

	# Open the about:addons page in a new tab to activate all installed extensions manually
	Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -ArgumentList "-new-tab about:addons"

	Remove-Item -Path "$DownloadsFolder\Extensions" -Recurse -Force
}

$Parameters = @{
	ExtensionUris = @(
		"https://addons.mozilla.org/firefox/addon/ublock-origin",
		"https://addons.mozilla.org/firefox/addon/traduzir-paginas-web",
		"https://addons.mozilla.org/firefox/addon/tampermonkey",
		"https://addons.mozilla.org/firefox/addon/sponsorblock",
		"https://addons.mozilla.org/firefox/addon/return-youtube-dislikes"
	)
	Hive = "HKCU"
}
Add-FirefoxExtension @Parameters

Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe"
Start-Sleep -Seconds 3

# Install additional JS scripts for Tampermonkey
# We need to open Firefox process first to be able to open new tabs. Unless every new tab will be opened in a new process
if (Test-Path -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions\firefox@tampermonkey.net.xpi")
{
	$Scripts = @(
		"https://greasyfork.org/scripts/19993-ru-adlist-js-fixes/code/RU%20AdList%20JS%20Fixes.user.js"
	)
	Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -ArgumentList "-new-tab $Scripts"
}

# https://gitlab.com/magnolia1234/bypass-paywalls-firefox-clean
Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -ArgumentList "-new-tab https://gitlab.com/magnolia1234/bypass-paywalls-firefox-clean"

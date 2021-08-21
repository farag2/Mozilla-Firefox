<#
	.SYNOPSIS
	Add extensions to Firefox automatically

	.PARAMETER ExtensionUri
	Copy URL on an extesion page by right-clicking on the Download button

	.PARAMETER Hive
	HKLM affects every user of a machine, HKCU will affect only the primary user

	.EXAMPLE
	$Parameters = @{
		ExtensionUris = @("https://addons.mozilla.org/firefox/downloads/file/3816867/ublock_origin.xpi")
		Hive          = "HKCU"
	}
	New-FirefoxExtension @Parameters

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

	foreach ($Uri in $ExtensionUris)
	{
		# Downloading extension
		[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

		$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
		$Extension = Split-Path -Path $Uri -Leaf
		$Parameters = @{
			Uri = $Uri
			OutFile = "$DownloadsFolder\$Extension"
			Verbose = [switch]::Present
		}
		Invoke-WebRequest @Parameters

		# Copy file and rename it into .zip
		Get-Item -Path "$DownloadsFolder\$Extension" -Force | Foreach-Object -Process {
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
			Source  = "$DownloadsFolder\$Extension"
			Destination = "$DownloadsFolder"
			File= "manifest.json"
		}
		ExtractZIPFile @Parameters

		# Get the author id
		$manifest = Get-Content -Path "$DownloadsFolder\manifest.json" -Encoding Default -Force | ConvertFrom-Json
		# Some extensions don't have valid JSON manifest
		if ($null -ne $manifest.applications)
		{
			$ApplicationID = $manifest.applications.gecko.id
		}
		else
		{
			$ApplicationID = $manifest.browser_specific_settings.gecko.id
		}

		Get-Item -Path "$DownloadsFolder\$Extension" -Force | Rename-Item -NewName "$ApplicationID.xpi" -Force

		# Getting Firefox profile name
		$String = (Get-Content -Path "$env:APPDATA\Mozilla\Firefox\installs.ini" -Encoding Default | Select-String -Pattern "^\s*Default\s*=\s*.+" | ConvertFrom-StringData).Default
		$ProfileName = Split-Path -Path $String -Leaf

		if (-not (Test-Path -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions"))
		{
			New-Item -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions" -ItemType Directory -Force
		}

		# Copy .xpi extension file to the extensions folder
		Copy-Item -Path "$DownloadsFolder\$ApplicationID.xpi" -Destination "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions" -Force

		switch ($Hive)
		{
			"HKCU"
			{
				if (-not (Test-Path -Path HKCU:\Software\Mozilla\Firefox\Extensions))
				{
					New-Item -Path HKCU:\Software\Mozilla\Firefox\Extensions -Force
				}
				New-ItemProperty -Path HKCU:\Software\Mozilla\Firefox\Extensions -Name $ApplicationID -PropertyType String -Value "$DownloadsFolder\$ApplicationID.xpi" -Force
			}
			"HKLM"
			{
				if (-not (Test-Path -Path HKLM:\Software\Mozilla\Firefox\Extensions))
				{
					New-Item -Path HKLM:\Software\Mozilla\Firefox\Extensions -Force
				}
				New-ItemProperty -Path HKLM:\Software\Mozilla\Firefox\Extensions -Name $ApplicationID -PropertyType String -Value "$DownloadsFolder\$ApplicationID.xpi" -Force
			}
		}
	}
}

$Parameters = @{
	ExtensionUris = @(
		# https://addons.mozilla.org/firefox/addon/ublock-origin/
		"https://addons.mozilla.org/firefox/downloads/file/3816867/ublock_origin.xpi",
		# https://addons.mozilla.org/firefox/addon/traduzir-paginas-web/
		"https://addons.mozilla.org/firefox/downloads/file/3822990/traduzir_paginas_web.xpi",
		# https://addons.mozilla.org/firefox/addon/tampermonkey/
		"https://addons.mozilla.org/firefox/downloads/file/3768983/tampermonkey.xpi",
		# https://addons.mozilla.org/firefox/addon/sponsorblock/
		"https://addons.mozilla.org/firefox/downloads/file/3820687/sponsorblock_skip_sponsorships_on_youtube.xpi"
	)
	Hive          = "HKCU"
}
Add-FirefoxExtension @Parameters

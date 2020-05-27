# Close Firefox
$firefox = Get-Process -Name firefox -ErrorAction SilentlyContinue
if ($firefox)
{
	$firefox.CloseMainWindow()
}
Start-Sleep -Seconds 1

# Check whether extensions installed
$uBlockOrigin = Get-Item -Path $env:APPDATA\Mozilla\Firefox\Profiles\*default*\extensions\uBlock0@raymondhill.net.xpi
$defaultbookmarkfolder = Get-Item -Path $env:APPDATA\Mozilla\Firefox\Profiles\*default*\extensions\default-bookmark-folder@gustiaux.com.xpi
if (-not ($uBlockOrigin) -or (-not ($defaultbookmarkfolder)))
{
	$extensions = @(
		# uBlock Origin
		"https://addons.mozilla.org/ru/firefox/addon/ublock-origin/",
		# Default Bookmark Folder
		"https://addons.mozilla.org/ru/firefox/addon/default-bookmark-folder/"
	)
	Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -ArgumentList $extensions
}

# Turn off all scheduled tasks in Mozilla folder
# Отключить все запланированные задачи в папке Mozilla
Get-ScheduledTask -TaskPath "\Mozilla\" | Disable-ScheduledTask

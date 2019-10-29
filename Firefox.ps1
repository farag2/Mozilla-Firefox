# Close Firefox
$firefox = Get-Process -Name firefox -ErrorAction SilentlyContinue
IF ($firefox)
{
	$firefox.CloseMainWindow()
}
Start-Sleep -Seconds 1
# Get uBlock Origin install path
$ublock = Get-Item -Path $env:APPDATA\Mozilla\Firefox\Profiles\*default*\extensions\uBlock0@raymondhill.net.xpi
$prefsjs = (Get-Item -Path $env:APPDATA\Mozilla\Firefox\Profiles\*default*\prefs.js).FullName
IF ($ublock)
{
	# Toolbar with uBlock Origin installed
	$userjs = 'user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"urlbar-container\",\"home-button\",\"stop-reload-button\",\"bookmarks-menu-button\",\"downloads-button\",\"fxa-toolbar-menu-button\",\"ublock0_raymondhill_net-browser-action\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\",\"ublock0_raymondhill_net-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"widget-overflow-fixed-list\",\"toolbar-menubar\",\"TabsToolbar\",\"PersonalToolbar\"],\"currentVersion\":16,\"newElementCount\":3}");'
	Add-Content -Path $prefsjs -Value "$userjs" -Force
}
Else
{
	# Toolbar without uBlock Origin installed
	$userjs = 'user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"urlbar-container\",\"home-button\",\"stop-reload-button\",\"bookmarks-menu-button\",\"downloads-button\",\"fxa-toolbar-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\",\"ublock0_raymondhill_net-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"widget-overflow-fixed-list\",\"toolbar-menubar\",\"TabsToolbar\",\"PersonalToolbar\"],\"currentVersion\":16,\"newElementCount\":3}");'
	Add-Content -Path $prefsjs -Value "$userjs" -Force
	$extensions = @(
		# uBlock Origin
		"https://addons.mozilla.org/ru/firefox/addon/ublock-origin/",
		# Default Bookmark Folder
		"https://addons.mozilla.org/ru/firefox/addon/default-bookmark-folder/"
	)
	Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -ArgumentList $extensions
}

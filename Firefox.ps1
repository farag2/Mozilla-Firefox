# Close Firefox
$firefox = Get-Process -Name firefox -ErrorAction SilentlyContinue
if ($firefox)
{
	$firefox.CloseMainWindow()
}
Start-Sleep -Seconds 1

# Configure Toolbar
# Настроить панель инструментов

# Getting profile name
# Получаем имя профиля
$String = Get-Content -Path "$env:APPDATA\Mozilla\Firefox\installs.ini" | Select-String -Pattern "Default="
$Folder = Split-Path -Path $String -Leaf
 
$prefsjs = "$env:APPDATA\Mozilla\Firefox\Profiles\$Folder\prefs.js"

# Finding, where the Toolbar settings store
# Находим строку, где хранятся настройки панели управления
$String = Get-Content -Path $prefsjs | Select-String -Pattern "browser.uiCustomization.state" -SimpleMatch
# Deleting all "\" in the string
# Удаляем в строке все "\"
$String2 = ($String).Tostring().replace("\", "")
# Deleting the first 44 characters to delete 'user_pref("browser.uiCustomization.state", "'
# Удаляем в строке первые 44 символа, чтобы отбросить 'user_pref("browser.uiCustomization.state", "'
$Substring = $String2.Substring(44)
# Deleting the last 3 characters to delete '");'
# Удаляем в строке последние 3 символа, чтобы отбросить '");'
[Object]$QuickJson = $Substring.Substring(0,$Substring.Length-3)
 
[object]$JSON = ConvertFrom-Json -InputObject $QuickJson
# The necessary buttons sequence
# Необходимая последовательность кнопок
$NavBar = (
	# Go back one page
	# На предыдущую страницу
	"back-button",
	# Go forward one page
	# На следующую страницу
	"forward-button",
	# Address bar
	# Адресная строка
	"urlbar-container",
	# Firefox Home Page
	# Домащняя страница Firefox
	"home-button",
	# Reload Current Page
	# Обновить текущую страницу
	"stop-reload-button",
	# Show your bookmarks
	# Показать ваши закладки
	"bookmarks-menu-button",
	# Firefox Account
	# Аккаунт Firefox
	"fxa-toolbar-menu-button"
)
$JSON.placements.'nav-bar' = $NavBar
$ConfiguredJSON = $JSON | ConvertTo-Json -Depth 10
# Replacing all '"' with '\"', as it was
# Заменяем все '"' на '\"', как было
$ConfiguredString = $ConfiguredJSON.replace('"', '\"').ToString()
 
# Replace the entire string with the result
# Заменяем всю строку на полученный результат
$replace = "user_pref(`"browser.uiCustomization.state`", `"$ConfiguredString`");"
(Get-Content -Path $prefsjs).replace($String, $replace) | Set-Content $prefsjs -Force 

# Check whether extensions installed
# Проверить, установлены ли расширения
$uBlockOrigin = Get-Item -Path $env:APPDATA\Mozilla\Firefox\Profiles\*default*\extensions\uBlock0@raymondhill.net.xpi
$DefaultBookmarkFolder = Get-Item -Path $env:APPDATA\Mozilla\Firefox\Profiles\*default*\extensions\default-bookmark-folder@gustiaux.com.xpi
if (-not ($uBlockOrigin))
{
	# uBlock Origin
	Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -ArgumentList "https://addons.mozilla.org/ru/firefox/addon/ublock-origin/"
}
if (-not ($DefaultBookmarkFolder))
{
	# Default Bookmark Folder
	Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -ArgumentList "https://addons.mozilla.org/ru/firefox/addon/default-bookmark-folder/"
}

# Turn off all scheduled tasks in Mozilla folder
# Отключить все запланированные задачи в папке Mozilla
Get-ScheduledTask -TaskPath "\Mozilla\" | Disable-ScheduledTask

# Close Firefox
# Закрыть Firefox
Get-Process -Name firefox -ErrorAction Ignore | Stop-Process -Force
Start-Sleep -Seconds 1

# Configuring Toolbar
# Настраиваем панель инструментов

# Getting profile name
# Получаем имя профиля
$String = Get-Content -Path "$env:APPDATA\Mozilla\Firefox\installs.ini" | Select-String -Pattern "Default="
$Profile = Split-Path -Path $String -Leaf

$prefsjs = "$env:APPDATA\Mozilla\Firefox\Profiles\$Profile\prefs.js"

# Finding, where the Toolbar settings store
# Находим строку, где хранятся настройки панели управления
$String = Get-Content -Path $prefsjs | Select-String -Pattern "browser.uiCustomization.state" -SimpleMatch
# Deleting all "\" in the string
# Удаляем в строке все "\"
$String2 = $String.ToString().Replace("\", "")
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
(Get-Content -Path $prefsjs).Replace($String, $replace) | Set-Content -Path $prefsjs -Force

# Turn off all scheduled tasks in Mozilla folder
# Отключить все запланированные задачи в папке Mozilla
Get-ScheduledTask -TaskPath "\Mozilla\" | Disable-ScheduledTask

# Download files
# Скачать файлы
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Parameters = @{
	Uri = "https://github.com/farag2/Mozilla-Firefox/raw/master/search.json.mozlz4"
	OutFile = "$env:APPDATA\Mozilla\Firefox\Profiles\$Profile\search.json.mozlz4"
	Verbose = [switch]::Present
}
Invoke-WebRequest @Parameters

$Parameters = @{
	Uri = "https://raw.githubusercontent.com/farag2/Mozilla-Firefox/master/user.js"
	OutFile = "$env:APPDATA\Mozilla\Firefox\Profiles\$Profile\user.js"
	Verbose = [switch]::Present
}
Invoke-WebRequest @Parameters
Start-Process -FilePath "$env:APPDATA\Mozilla\Firefox\Profiles\$Profile"

if (-not (Test-Path -Path $env:APPDATA\Mozilla\Firefox\Profiles\$Profile\chrome))
{
	New-Item -Path $env:APPDATA\Mozilla\Firefox\Profiles\$Profile\chrome -ItemType Directory -Force
}
$Parameters = @{
	Uri = "https://raw.githubusercontent.com/farag2/Mozilla-Firefox/master/chrome/userChrome.css"
	OutFile = "$env:APPDATA\Mozilla\Firefox\Profiles\$Profile\chrome\userChrome.css"
	Verbose = [switch]::Present
}
Invoke-WebRequest @Parameters

# Check whether extensions installed
# Проверить, установлены ли расширения
$uBlockOrigin = Get-Item -Path $env:APPDATA\Mozilla\Firefox\Profiles\$Profile\extensions\uBlock0@raymondhill.net.xpi -ErrorAction Ignore
$DefaultBookmarkFolder = Get-Item -Path $env:APPDATA\Mozilla\Firefox\Profiles\$Profile\extensions\default-bookmark-folder@gustiaux.com.xpi -ErrorAction Ignore
$TranslateWebPages = Get-Item -Path "$env:APPDATA\Mozilla\Firefox\Profiles\$Profile\extensions\{036a55b4-5e72-4d05-a06c-cba2dfcc134a}.xpi" -ErrorAction Ignore
if (-not ($uBlockOrigin))
{
	# uBlock Origin
	Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -ArgumentList "https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/"
}
if (-not ($DefaultBookmarkFolder))
{
	# Default Bookmark Folder
	Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -ArgumentList "https://addons.mozilla.org/en-US/firefox/addon/default-bookmark-folder/"
}
if (-not ($TranslateWebPages))
{
	# Translate Web Pages
	Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -ArgumentList "https://addons.mozilla.org/en-US/firefox/addon/traduzir-paginas-web/"
}
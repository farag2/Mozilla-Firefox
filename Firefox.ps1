# Close Firefox
# Закрыть Firefox
Get-Process -Name firefox -ErrorAction Ignore | Stop-Process -Force
Start-Sleep -Seconds 1

# Configuring Toolbar
# Настраиваем панель инструментов

# Getting profile name
# Получаем имя профиля
$String = Get-Content -Path "$env:APPDATA\Mozilla\Firefox\installs.ini" | Select-String -Pattern "Default="
$ProfileName = Split-Path -Path $String -Leaf

$prefsjs = "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\prefs.js"

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

# Download search.json.mozlz4
# Скачать search.json.mozlz4
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Parameters = @{
	Uri = "https://github.com/farag2/Mozilla-Firefox/raw/master/search.json.mozlz4"
	OutFile = "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\search.json.mozlz4"
	Verbose = [switch]::Present
}
Invoke-WebRequest @Parameters

# Download user.js
# Скачать user.js
$Parameters = @{
	Uri = "https://raw.githubusercontent.com/farag2/Mozilla-Firefox/master/user.js"
	OutFile = "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\user.js"
	Verbose = [switch]::Present
}
Invoke-WebRequest @Parameters
Start-Process -FilePath $env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName

# Download userChrome.css
# Скачать userChrome.css
if (-not (Test-Path -Path $env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\chrome))
{
	New-Item -Path $env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\chrome -ItemType Directory -Force
}
$Parameters = @{
	Uri = "https://raw.githubusercontent.com/farag2/Mozilla-Firefox/master/chrome/userChrome.css"
	OutFile = "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\chrome\userChrome.css"
	Verbose = [switch]::Present
}
Invoke-WebRequest @Parameters

# Check whether extensions installed
# Проверить, установлены ли расширения
$Extensions = @{
	# uBlock Origin
	"$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions\uBlock0@raymondhill.net.xpi" = "https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/"
	# Default Bookmark Folder
	"$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions\default-bookmark-folder@gustiaux.com.xpi" = "https://addons.mozilla.org/en-US/firefox/addon/default-bookmark-folder/"
	# Translate Web Pages
	"$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName\extensions\{036a55b4-5e72-4d05-a06c-cba2dfcc134a}.xpi" = "https://addons.mozilla.org/en-US/firefox/addon/traduzir-paginas-web/"
}
foreach ($Extension in $Extensions.Keys)
{
	if (-not (Test-Path -Path $Extension))
	{
		Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -ArgumentList $Extensions[$Extension]
	}
}
for /d %%i in (%APPDATA%\Mozilla\Firefox\Profiles\*.default*) do (
	robocopy "%~dp0." %%i user.js
	robocopy "%~dp0." %%i search.json.mozlz4
)
explorer %APPDATA%\Mozilla\Firefox\Profiles
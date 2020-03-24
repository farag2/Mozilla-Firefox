for /d %%i in (%APPDATA%\Mozilla\Firefox\Profiles\*.default*) do (
robocopy "%~dp0chrome" "%%i\chrome" /COPYALL /E
)
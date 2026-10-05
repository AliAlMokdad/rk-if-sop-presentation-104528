@echo off
rem The presentation, ready to give: a small local web server for this folder, then Chrome at its address.
rem (Opened straight from the file, Chrome would not let the book read its pages.) Works with no internet.
cd /d "%~dp0"
set "PY="
where py >nul 2>nul && set "PY=py -3"
if not defined PY if exist "%LOCALAPPDATA%\Python\bin\python.exe" set "PY="%LOCALAPPDATA%\Python\bin\python.exe""
if not defined PY where python >nul 2>nul && set "PY=python"
if not defined PY (
  echo Python was not found, so the local server cannot start.
  pause
  exit /b 1
)
netstat -ano | findstr /r /c:"127.0.0.1:8765 .*LISTENING" >nul
if errorlevel 1 (
  start "Presentation server" /min %PY% -m http.server 8765 --bind 127.0.0.1
  timeout /t 2 /nobreak >nul
)
set "CHROME=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if not exist "%CHROME%" set "CHROME=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
if not exist "%CHROME%" set "CHROME=%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe"
if exist "%CHROME%" (
  start "" "%CHROME%" "http://127.0.0.1:8765/index.html"
) else (
  start "" "http://127.0.0.1:8765/index.html"
)

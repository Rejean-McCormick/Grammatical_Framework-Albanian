@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ---- BASE PATHS ----
for %%I in ("%~dp0.") do set "SCRIPT_DIR=%%~fI"
for %%I in ("%SCRIPT_DIR%\..") do set "WORK_ROOT=%%~fI"

REM ---- CONFIG ----
set "AUDIT_PS1=%SCRIPT_DIR%\gf_audit.ps1"
set "PROJECT_ROOT=%SCRIPT_DIR%\AlbanianSQI\GF"
set "RGL_ROOT=%WORK_ROOT%\gf-rgl\src"
set "OUT_ROOT=%SCRIPT_DIR%\_gf_audit"
set "GF_EXE=%WORK_ROOT%\gf-3.12-windows\gf.exe"
set "TIMEOUT_SEC=60"

REM ---- PREP LOG PATHS ----
if not exist "%OUT_ROOT%" mkdir "%OUT_ROOT%" >nul 2>&1
for /f %%I in ('powershell -NoProfile -Command "(Get-Date).ToString(\"yyyyMMdd_HHmmss\")"') do set "TS=%%I"
set "LAUNCH_LOG=%OUT_ROOT%\launcher_%TS%.log"
set "TRANSCRIPT=%OUT_ROOT%\launcher_%TS%_transcript.txt"

echo ================================================== > "%LAUNCH_LOG%"
echo Launch time: %date% %time%>> "%LAUNCH_LOG%"
echo SCRIPT_DIR=%SCRIPT_DIR%>> "%LAUNCH_LOG%"
echo WORK_ROOT=%WORK_ROOT%>> "%LAUNCH_LOG%"
echo AUDIT_PS1=%AUDIT_PS1%>> "%LAUNCH_LOG%"
echo PROJECT_ROOT=%PROJECT_ROOT%>> "%LAUNCH_LOG%"
echo RGL_ROOT=%RGL_ROOT%>> "%LAUNCH_LOG%"
echo OUT_ROOT=%OUT_ROOT%>> "%LAUNCH_LOG%"
echo GF_EXE=%GF_EXE%>> "%LAUNCH_LOG%"
echo TIMEOUT_SEC=%TIMEOUT_SEC%>> "%LAUNCH_LOG%"
echo TRANSCRIPT=%TRANSCRIPT%>> "%LAUNCH_LOG%"
echo ================================================== >> "%LAUNCH_LOG%"

REM ---- PRE-FLIGHT CHECKS ----
if not exist "%AUDIT_PS1%" (
  echo ERROR: gf_audit.ps1 not found: "%AUDIT_PS1%" >> "%LAUNCH_LOG%"
  echo ERROR: gf_audit.ps1 not found: "%AUDIT_PS1%"
  pause
  exit /b 2
)
if not exist "%PROJECT_ROOT%" (
  echo ERROR: Project root not found: "%PROJECT_ROOT%" >> "%LAUNCH_LOG%"
  echo ERROR: Project root not found: "%PROJECT_ROOT%"
  pause
  exit /b 2
)
if not exist "%RGL_ROOT%" (
  echo ERROR: RGL root not found: "%RGL_ROOT%" >> "%LAUNCH_LOG%"
  echo ERROR: RGL root not found: "%RGL_ROOT%"
  pause
  exit /b 2
)
if not exist "%RGL_ROOT%\abstract\Cat.gf" (
  echo ERROR: Expected RGL file not found: "%RGL_ROOT%\abstract\Cat.gf" >> "%LAUNCH_LOG%"
  echo ERROR: Expected RGL file not found: "%RGL_ROOT%\abstract\Cat.gf"
  pause
  exit /b 2
)
if not exist "%GF_EXE%" (
  echo ERROR: gf.exe not found: "%GF_EXE%" >> "%LAUNCH_LOG%"
  echo ERROR: gf.exe not found: "%GF_EXE%"
  pause
  exit /b 2
)
where pwsh >nul 2>&1
if errorlevel 1 (
  echo ERROR: pwsh not found on PATH. >> "%LAUNCH_LOG%"
  echo ERROR: pwsh not found on PATH.
  pause
  exit /b 2
)

REM ---- RUN (PowerShell wrapper captures full exception + stack) ----
echo Running gf_audit... (see transcript)
echo Running gf_audit... >> "%LAUNCH_LOG%"

pwsh -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop';" ^
  "Start-Transcript -Path '%TRANSCRIPT%' -Force | Out-Null;" ^
  "Write-Host ('PSVersion=' + $PSVersionTable.PSVersion);" ^
  "try {" ^
  "  & '%AUDIT_PS1%' -ProjectRoot '%PROJECT_ROOT%' -RglRoot '%RGL_ROOT%' -GfExe '%GF_EXE%' -OutRoot '%OUT_ROOT%' -TimeoutSec %TIMEOUT_SEC%;" ^
  "  exit 0" ^
  "} catch {" ^
  "  Write-Host 'FATAL ERROR:';" ^
  "  Write-Host ($_.Exception.ToString());" ^
  "  if ($_.ScriptStackTrace) { Write-Host '--- ScriptStackTrace ---'; Write-Host $_.ScriptStackTrace }" ^
  "  exit 1" ^
  "} finally {" ^
  "  try { Stop-Transcript | Out-Null } catch {}" ^
  "}"

set "RC=%ERRORLEVEL%"
echo ExitCode=%RC%>> "%LAUNCH_LOG%"

echo.
echo Done. ExitCode=%RC%
echo Launcher log:
echo   %LAUNCH_LOG%
echo Transcript (will contain the real error):
echo   %TRANSCRIPT%
echo.
pause
endlocal
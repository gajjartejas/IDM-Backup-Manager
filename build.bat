@echo off
setlocal
cd /d "%~dp0"
echo ==========================================================
echo Starting IDM Backup Manager Build Script...
echo ==========================================================

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0build.ps1" %*

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Build failed with exit code %ERRORLEVEL%.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo Build finished successfully.
endlocal

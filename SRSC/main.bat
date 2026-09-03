@echo off
title 崩铁快速切服(BAT版)
color 0a

REM ===== 自动提权 =====
fltmc >nul 2>&1 || (
    echo 需要管理员权限，正在请求...
    PowerShell -NoProfile -Command "Start-Process -FilePath '%0' -Verb RunAs"
    exit /b
)

set "GAME_DIR=C:\Program Files\miHoYo Launcher\games\Star Rail Game"
set "CFG=%GAME_DIR%\config.ini"

REM ===== 检测当前服务器 =====
set "CURRENT=未知"
findstr /C:"cps=bilibili_PC" "%CFG%" >nul 2>&1
if %errorlevel%==0 set "CURRENT=B服"
findstr /C:"cps=gw_PC" "%CFG%" >nul 2>&1
if %errorlevel%==0 set "CURRENT=官服"

cls
echo.
echo ========================================
echo   崩铁快速切服(BAT版)
echo ========================================
echo.
echo   当前服务器：%CURRENT%
echo.
echo   1. 官服 (gw_PC)
echo   2. B服 (bilibili_PC)
echo.
echo ========================================
echo.

set /p c=请输入数字 [1/2]：

if "%c%"=="1" goto :OFFICIAL
if "%c%"=="2" goto :BILIBILI

echo.
echo 输入有误，按任意键退出...
pause >nul
exit /b

:OFFICIAL
powershell -NoProfile -Command "(Get-Content '%CFG%') -replace 'channel=.*','channel=1' -replace 'cps=.*','cps=gw_PC' -replace 'sub_channel=.*','sub_channel=1' | Set-Content '%CFG%'"
goto :SHOW_OK

:BILIBILI
powershell -NoProfile -Command "(Get-Content '%CFG%') -replace 'channel=.*','channel=14' -replace 'cps=.*','cps=bilibili_PC' -replace 'sub_channel=.*','sub_channel=0' | Set-Content '%CFG%'"
goto :SHOW_OK

:SHOW_OK
cls
echo.
echo ========================================
echo   操作成功！
echo ========================================
echo.
echo --- config.ini 当前值 ---
findstr /C:"channel=" "%CFG%"
findstr /C:"cps=" "%CFG%"
findstr /C:"sub_channel=" "%CFG%"
echo.
pause
exit /b
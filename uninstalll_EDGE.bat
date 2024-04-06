@ECHO OFF
SETLOCAL
taskkill /IM msegde.exe -F
DEL /Q %~dp0\rmv_ms_edge_tmp_*_.txt

ECHO @ECHO OFF> %~dp0\RMV_MS_EDGE_.bat
ECHO SETLOCAL>> %~dp0\RMV_MS_EDGE_.bat

IF NOT EXIST "%ProgramFiles(x86)%\Microsoft\EdgeWebView" GOTO SKIP_1_LBL
CD /D %ProgramFiles(x86)%\Microsoft\EdgeWebView\Application
DIR /B /S *setup*> %~dp0\rmv_ms_edge_tmp_1_.txt
FOR /F "tokens=* delims=" %%A IN (%~dp0\rmv_ms_edge_tmp_1_.txt) DO (CALL :EDGE_RMV_1_ "%%A")
:SKIP_1_LBL

IF NOT EXIST "%ProgramFiles(x86)%\Microsoft\Edge" GOTO SKIP_2_LBL
CD /D %ProgramFiles(x86)%\Microsoft\Edge\Application
DIR /B /S *setup*> %~dp0\rmv_ms_edge_tmp_2_.txt
FOR /F "tokens=* delims=" %%B IN (%~dp0\rmv_ms_edge_tmp_2_.txt) DO (CALL :EDGE_RMV_2_ "%%B")
:SKIP_2_LBL

IF NOT EXIST "%ProgramFiles(x86)%\Microsoft\EdgeCore" GOTO SKIP_3_LBL
CD /D %ProgramFiles(x86)%\Microsoft\EdgeCore
DIR /B /S *setup*> %~dp0\rmv_ms_edge_tmp_3_.txt
FOR /F "tokens=* delims=" %%C IN (%~dp0\rmv_ms_edge_tmp_3_.txt) DO (CALL :EDGE_RMV_2_ "%%C")
:SKIP_3_LBL

ECHO ENDLOCAL>> %~dp0\RMV_MS_EDGE_.bat
ECHO DEL /Q %%~dp0\RMV_MS_EDGE_.bat>> %~dp0\RMV_MS_EDGE_.bat

GOTO LST_LNE_

:EDGE_RMV_1_
ECHO %~s1 --uninstall --msedgewebview --system-level --force-uninstall>> %~dp0\RMV_MS_EDGE_.bat
GOTO :EOF
:EDGE_RMV_2_
ECHO %~s1 --uninstall --system-level --force-uninstall>> %~dp0\RMV_MS_EDGE_.bat
GOTO :EOF
:LST_LNE_

CALL %~dp0\RMV_MS_EDGE_.bat
DEL /Q %~dp0\rmv_ms_edge_tmp_*_.txt

RMDIR /S /Q "%ProgramFiles%\Microsoft\EdgeUpdater"
RMDIR /S /Q "%ProgramFiles(x86)%\Microsoft\EdgeWebView"
RMDIR /S /Q "%ProgramFiles(x86)%\Microsoft\Edge"
RMDIR /S /Q "%ProgramFiles(x86)%\Microsoft\EdgeCore"
RMDIR /S /Q "%ProgramData%\Microsoft\EdgeUpdate"
RMDIR /S /Q "%AppData%\Microsoft\Edge"
RMDIR /S /Q "%LocalAppData%\Microsoft\Edge"

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Remove-NetFirewallRule -DisplayName '*Microsoft Edge*'}"

ENDLOCAL
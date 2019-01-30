:: Assume one and only one parameter is given to us.
:: Say it is <FOO>.
:: Start <FOO>.txt, from the data subdir of this batch file's dir.
::
@echo off
setlocal
set instance=%1
set file=%~dp0data\%instance%.txt
set path=%path%;%~dp0..
set url_path=notepad/%instance%
set windowtitle=%instance% - Notepad

for /f "usebackq" %%i in (`call get_value.cmd %url_path%/state/current`) do (
  set current_state=%%i
)
for /f "usebackq" %%i in (`call get_value.cmd %url_path%/state/desired`) do (
  set desired_state=%%i
)

:: If the desired state is running and the current state is stopped,
:: start it!
::
if "%desired_state%" equ "running" (
  if "%current_state%" equ "stopped" (
  call set_value.cmd starting %url_path%/state/current
  start /min notepad.exe %file%
  )
)
if "%desired_state%" equ "stopped" (
  if "%current_state%" == "running" (
    call set_value.cmd stopping %url_path%/state/current
    start /min "" cmd /c "taskkill /f /im notepad.exe /fi ^"WINDOWTITLE eq %windowtitle%^""
  )
)

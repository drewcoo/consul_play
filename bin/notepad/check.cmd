:: Look for a notepad instance name <ARG1>.txt,
:: where <ARG1> is the parameter passed to this batch file.
::
:: Set a watched key/value pair. Tell it whether or not we're running.
::
@echo off
setlocal
set instance=%1
set get_value=call %~dp0..\get_value.cmd
set set_value=call %~dp0..\set_value.cmd

:: Set current state
tasklist /FI "IMAGENAME eq notepad.exe" ^
  /FI "WINDOWTITLE eq %instance% - Notepad" ^
  |findstr Image > NUL
if 0 == %ERRORLEVEL% (set state=running) else (set state=stopped)
%set_value% %state% notepad/%instance%/state/current

:: Check following
::
:: get the leader
for /f "usebackq" %%i in (`%get_value% notepad/%instance%/follow`) do (
  set leader=%%i
)
if "%leader%" equ "" goto :CLEANUP

for /f "usebackq" %%i in (`%get_value% notepad/%leader%/state/desired`) do (
  set desired_leader_state=%%i
)

for /f "usebackq" %%i in (`%get_value% notepad/%leader%/state/current`) do (
  set current_leader_state=%%i
)

for /f "usebackq" %%i in (`%get_value% notepad/%instance%/state/desired`) do (
  set desired_instance_state=%%i
)

for /f "usebackq" %%i in (`%get_value% notepad/%instance%/state/current`) do (
  set current_instance_state=%%i
)

:: Follow the leader. If we're not in or about to be in the leader's
:: state, set the desired state to that.
:: For stable states. And it's stable if current == desired.
::
if "%current_leader_state%" equ "%desired_leader_state%" (
  if "%desired_instance_state%" neq "%desired_leader_state%" (
    %set_value% %desired_leader_state% notepad/%instance%/state/desired
  )
)

:CLEANUP

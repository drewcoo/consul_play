::
:: Do some horrible contortions to fix up absolute paths in the config json
:: before starting this.
::
:: Start in dev mode because that's one-machine combined client/server mode.
::
::@echo off
setlocal
set CONSUL_DIR=%~dp0..
set ORIG_FILE=%CONSUL_DIR%\config\base_consul_config.json
set CONFIG_FILE=%CONSUL_DIR%\config\actual_config.json

for /f "usebackq" %%i in (`echo %CONSUL_DIR% ^|sed -e s/\\/\\\\\\\\/g`) do (
  set TARGET_DIR=%%i
)

sed -e s/REPLACEME_ROOT_DIRECTORY/%TARGET_DIR%/g %ORIG_FILE% > %CONFIG_FILE%

start "consul" cmd /k "consul agent -dev -config-file=%CONFIG_FILE%"

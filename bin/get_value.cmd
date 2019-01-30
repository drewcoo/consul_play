:: Assume one and only one param passed to batch file is the
:: URL path to a key, <ARG1> in:
::   http://127.0.0.1:8500/v1/kv/<ARG1>
:: Output the base64-decoded value of that key.
::
:: Dependencies:
::   choco install curl
::   choco install jq
::

@echo off
setlocal
set key_url_path=%1

:: Create a temp dir (under %tmp%) to work in. This is going
:: to get ugly because the version of jq we're using from choco is < 1.6.
:: That means we will use certutil to decode and it operates on files.
::
set temp_dir=%tmp%\%key_url_path:/=\%
mkdir %temp_dir% 2>NUL
set file_root=%temp_dir%\%random%

:: Grab the value from the key. It's base 64 encoded.
::
curl http://127.0.0.1:8500/v1/kv/%key_url_path% 2>NUL ^
  |jq -r .[0].Value > %file_root%.b64

for /f "usebackq" %%i in (`type %file_root%.b64`) do (
  set result=%%i
)

::
:: Bail if for whatever reason that didn't work.
:: Possibly there was no key.
:: Possibly there was a race with file names.
:: Don't sweat those. We're eventually cool.
::
if "%result%" equ "null" (set result=)
if "%result%" equ "" (goto :GET_OUT)

:: Decode it.
::
certutil -decode %file_root%.b64 %file_root%.decoded >NUL

:: And read the result.
::
for /f "usebackq" %%i in (`more %file_root%.decoded`) do (
  set result=%%i
)

:: Clean up temp files.
:: But leave the dir in case something else is using it.
::
del %file_root%.*

:GET_OUT
if "%result%" neq "" (echo %result%)

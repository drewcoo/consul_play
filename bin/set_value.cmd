:: PUT value <ARG1> in http://localhost:8500/v1/kv/<ARG2>
::
@echo off
setlocal
set url_path=%2
set new_value=%1

curl -X PUT -d "%new_value%" http://127.0.0.1:8500/v1/kv/%url_path% 2>NUL

setlocal
set CONFIG_FILE=%~dp0..\config\consul_config.json
start "consul" cmd /k "consul agent -dev -config-file=%CONFIG_FILE%"

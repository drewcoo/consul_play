:: Stop the processes we're managing and then stop the parent consul window.
:: Or any consul windows.
::
taskkill /f /im notepad.exe
:: Start a new (ephemeral) cmd instance so that if we're calling from
:: the one entitled "consul" it can suicide. Without the trick, that fails.
start /min "" cmd /c "taskkill /f /im cmd.exe /fi ^"WINDOWTITLE eq consul^""

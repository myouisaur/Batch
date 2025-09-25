@echo off
:: Prompt for username
set /p USERNAME=Enter Username: 

:: Prompt for password (masked input using PowerShell)
for /F "delims=" %%P in ('powershell -Command "$pword = Read-Host 'Enter Password' -AsSecureString; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword))"') do set "PASSWORD=%%P"

:: Check and unmap existing drives before mapping new ones
echo.
echo Checking for existing drive mappings...

:: Check P: drive
net use P: >nul 2>&1
if %errorlevel% equ 0 (
    echo P: drive already exists, unmapping...
    net use P: /delete /yes
)

:: Check S: drive
net use S: >nul 2>&1
if %errorlevel% equ 0 (
    echo S: drive already exists, unmapping...
    net use S: /delete /yes
)

:: Check T: drive
net use T: >nul 2>&1
if %errorlevel% equ 0 (
    echo T: drive already exists, unmapping...
    net use T: /delete /yes
)

:: Map network drives with authentication and check for errors
echo.
echo Mapping P: drive...
net use P: \\anzfs1.int.thomsonreuters.com\apps$ /user:%USERNAME% %PASSWORD% /persistent:yes
if %errorlevel% neq 0 (
    echo ERROR: Failed to map P: drive
    goto :error
)

echo.
echo Mapping S: drive...
net use S: \\anzfs1.int.thomsonreuters.com\shared$ /user:%USERNAME% %PASSWORD% /persistent:yes
if %errorlevel% neq 0 (
    echo ERROR: Failed to map S: drive
    goto :error
)

echo.
echo Mapping T: drive...
net use T: \\anzfs1.int.thomsonreuters.com\temp$ /user:%USERNAME% %PASSWORD% /persistent:yes
if %errorlevel% neq 0 (
    echo ERROR: Failed to map T: drive
    goto :error
)

:: Only display success message if all commands succeeded
echo.
echo Network drives mapped successfully!
goto :end

:error
echo.
echo One or more network drives failed to map. Please check your credentials and network connectivity.

:end
pause

@echo off
setlocal

rem Directory to store the information
set output_dir=C:\Users\hacke\Desktop\eyenet_bootinfo

rem Create the directory if it does not exist
if not exist %output_dir% mkdir %output_dir%

rem Initialize file number
set file_number=1

rem Function to generate a unique file name
:generate_filename
set output_file=%output_dir%\bootupinfo-%date:~10,4%-%date:~4,2%-%date:~7,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%-%file_number%.txt

:check_file_exists
if exist %output_file% (
    set /a file_number+=1
    goto check_file_exists
)

goto proceed

:proceed
rem Get current time and date
for /f "tokens=1-3 delims=/ " %%a in ('date /t') do set mydate=%%c-%%a-%%b
for /f "tokens=1-2 delims=/:" %%a in ('time /t') do set mytime=%%a-%%b-%%c

rem Write current time and date to the file
echo Current Time and Date: %mydate% %mytime% > %output_file%

rem Get nearby networks (SSID only)
echo. >> %output_file%
echo Nearby Networks (SSIDs): >> %output_file%
for /f "tokens=2 delims=:" %%i in ('netsh wlan show networks ^| findstr /C:"SSID"') do echo %%i >> %output_file%

rem Get the currently connected network
echo. >> %output_file%
echo Currently Connected Network: >> %output_file%
for /f "tokens=2 delims=:" %%i in ('netsh wlan show interfaces ^| findstr /C:"SSID"') do echo %%i >> %output_file%

rem Get an overview of major processes running
echo. >> %output_file%
echo Major Processes Running: >> %output_file%
tasklist /v /fo table /nh | sort /+58 >> %output_file%

rem Get current geographical coordinates (requires external web request)
echo. >> %output_file%
echo Geographical Coordinates: >> %output_file%
for /f %%i in ('curl -s https://ipinfo.io/loc') do echo %%i >> %output_file%

rem Get public IP address (requires external web request)
echo. >> %output_file%
echo Public IP Address: >> %output_file%
for /f %%i in ('curl -s https://api.ipify.org') do echo %%i >> %output_file%

endlocal

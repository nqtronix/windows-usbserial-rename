@echo OFF

:: USER VARIABLES (change these to match your application)
:: enter VID and PID of the USB device; if you need an ID pair you can get it from pid.codes
set USB_DEVICE_VID=VID_1209
set USB_DEVICE_PID=PID_0001
:: enter the new device name, " (COMxx)" will be appended automatically
set USB_DEVICE_NAME=pid.codes - Test PID
:: Will be display at the start of file and in window titlebar
set APP_NAME=Demo Device
:: add a custom website to you project here
set APP_WEB=https://github.com/nqtronix/windows-usbserial-rename
:: if =true, developer information will be displayed
set APP_IS_DEVELOPER=true


:: SCRIPT (do not edit code below)
set AMPERSAND=^&
title windows usbserial rename - %APP_NAME%
echo:
echo #####  windows usbserial rename - %APP_NAME%  #####
echo:
echo ##############################################################################
echo:
echo:
echo By default windows installes a generic driver for all USB CDC serial devices
echo with a generic device name. This script replaces it with a custom name, making
echo it easy to identify in many programs.
echo:
echo It also works well with https://github.com/avishorp/PopCom to give you a
echo device specific pop-up whenever you connect or disconnect the device.
echo:
echo:
echo This script is set up to modify the device with the ID:
echo   %USB_DEVICE_VID%%AMPERSAND%%USB_DEVICE_PID%
echo:
echo The new name of the device will be:
echo   %USB_DEVICE_NAME% (COMxx)
echo:
echo You can find detailed information for your device here:
echo   %APP_WEB%
echo:
echo ##############################################################################
echo:
echo:

:: DO NOT REMOVE THE DEVELOPER INFORMATION, USE THE OPTION IN THE FIRST SECTION INSTEAD!
if /I "%APP_IS_DEVELOPER%" NEQ "true" (goto disclaimer)
echo Developer Information:
echo For demonstration purposes this script will use the test VID/PID combination
echo from the website pid.codes. To change the VID/PID or the device name please
echo edit the first section of this script with any text editor. If desired, you
echo may hide this notice by changing the 5th line to "set APP_IS_DEVELOPER=false"
echo:
echo Version: 1.0.0 (see semver.org)
echo Source:  https://github.com/nqtronix/windows-usbserial-rename
echo Tested on Windows 10 version 1709 build 16299.547
echo:
echo ##############################################################################
echo:
echo:

:disclaimer
echo Disclaimer:
echo This script works by changing a specific entry in the registry. Because
echo unintentional modifications to the registry might break windows, several
echo checks are performed to validate the user input and check if your system is
echo compatible. Despite this we can not guarantee 100% flawless opreation
echo on all systems and are not responsible for any damage to your system.
echo:
echo PROCEED AT YOUR OWN RISK!
echo:
echo:

:choice
set /P c=Are you sure you want to continue [YES/NO/LICENSE]? 
if /I "%c%" EQU "YES" goto :start
if /I "%c%" EQU "NO" goto :realexit
if /I "%c%" EQU "LICENSE" goto :license
goto :choice


:license
echo:
echo:
echo ##############################################################################
echo:
echo MIT License
echo:
echo Copyright (c) 2018 nqtronix (github.com/nqtronix)
echo:
echo Permission is hereby granted, free of charge, to any person obtaining a copy
echo of this software and associated documentation files (the "Software"), to deal
echo in the Software without restriction, including without limitation the rights
echo to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
echo copies of the Software, and to permit persons to whom the Software is
echo furnished to do so, subject to the following conditions:
echo:
echo The above copyright notice and this permission notice shall be included in all
echo copies or substantial portions of the Software.
echo:
echo THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
echo IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
echo FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
echo AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
echo LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
echo OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
echo SOFTWARE.
echo:
echo ##############################################################################
echo:
echo:

goto choice

:start
echo:
echo ##############################################################################
echo:
echo:

:: Hi! You've found a hidden message! It's good to know that you are smart enough
:: to NOT run a file from some random dude on the internet. However you'll also
:: notice that I'm not particularly experienced with batch programming. Feel free
:: to fork me at https://github.com/nqtronix/windows-usbserial-rename and improve
:: the code.
:: Thanks!


::##############################################################################
::##  Prepare working directory
::##############################################################################

::create temporary working directory
@echo off
if not exist "%temp%\batch_tmp_delete_me" mkdir %temp%\batch_tmp_delete_me 2>nul
cd /d %temp%\batch_tmp_delete_me

:: clean all temporary files currently in folder
del tmp_* 2>nul


::##############################################################################
::##  Get the port number "COMxx" for each device
::##############################################################################
::REG QUERY "HKLM\SYSTEM\CurrentControlSet\Enum\USB\%USB_DEVICE_VID%&%USB_DEVICE_PID%" > tmp_listid

:: get a list of all devices with given PID/VID combination
echo REG QUERY "HKLM\SYSTEM\CurrentControlSet\Enum\USB\%USB_DEVICE_VID%%AMPERSAND%%USB_DEVICE_PID%" > tmp_cli_read_ids
for /F "tokens=*" %%A in (tmp_cli_read_ids) do (
  %%A >> tmp_listid 2>nul
)

:: check if file is empty:
:: YES -> No Windows driver found, display error
:: NO  -> Windows driver found, proceed with renaming
set /a size=0
for /f %%i in ("tmp_listid") do set size=%%~zi
if %size% gtr 0 goto rename

echo ERROR: No generic Windows serial driver for given VID/PID combination found.
echo Please connect your device first and let Windows install its drivers.
goto exit


::##############################################################################
::##  Extract & refine "COMxx" for each device
::##############################################################################

:rename
:: for each device create command to get port number
for /F "tokens=*" %%A in (tmp_listid) do (
  (echo REG QUERY "%%A\Device Parameters" /v PortName)>>tmp_cli_read_port
)

:: run all commands
for /F "tokens=*" %%A in (tmp_cli_read_port) do (
  %%A >> tmp_port1 2>tmp_error1
)

:: check if file is empty:
:: YES -> Serial device, proceed with renaming
:: NO  -> Not a serial device, display error
set /a size=0
for /f %%i in ("tmp_error1") do set size=%%~zi
if %size% EQU 0 (goto rename_continue)

echo ERROR: At least one device with given VID/PID has not "PortName" specified
echo and is thus likely not a serial device. Operation canceled.
goto exit

:rename_continue
:: extract the lines containing "COMxx"
setlocal enabledelayedexpansion
SET /a counter=0
for /f "usebackq delims=" %%a in (tmp_port1) do (
  set /a "testcond=(counter-1)%%2"
  if "!testcond!"=="0" echo %%a >> tmp_port2
  set /a counter+=1
)
endlocal

:: delete prefix from "COMxx"
setlocal enabledelayedexpansion
for /f "delims=" %%a in (tmp_port2) do (
    set line=%%a
    set line=!line:    PortName    REG_SZ    =!
    if "!line:~-1!"=="." set line=!line:~0,-1!
    >> tmp_port3 echo !line!
)
endlocal

:: delete suffix from "COMxx"
setlocal enabledelayedexpansion
for /f "delims=" %%a in (tmp_port3) do (
    set line=%%a
    set line=!line: =!
    if "!line:~-1!"=="." set line=!line:~0,-1!
    >> tmp_port echo !line!
)
endlocal

::##############################################################################
::##  Merge new device name and port name (COMx) and write result to registry
::##############################################################################

:: merge files
setlocal EnableDelayedExpansion
::Load first file into A1 array:
set i=0
for /F "delims=" %%a in (tmp_listid) do (
  set /A i+=1
  set A1[!i!]=%%a
)
::Load second file into A2 array:
set i=0
for /F "delims=" %%a in (tmp_port) do (
  set /A i+=1
  set A2[!i!]=%%a
)
::At this point, the number of lines is in %i% variable
::Merge data from both files and create the third one:
for /L %%i in (1,1,%i%) do (
  (echo REG ADD "!A1[%%i]!" /v FriendlyName /d "%USB_DEVICE_NAME% ^(!A2[%%i]!^)" /f)>> tmp_cli_write
)
endlocal

:: run all commands
for /F "tokens=*" %%A in (tmp_cli_write) do (
  %%A >nul 2>tmp_error2
)

:: check if file is empty:
:: YES -> Windows driver found, proceed with renaming
:: NO  -> No Windows driver found, display error
set /a size=0
for /f %%i in ("tmp_error2") do set size=%%~zi
if %size% EQU 0 (goto rename_complete)

echo ERROR: Access denied.
echo Please run the script again with administrator privileges.
goto exit


:rename_complete
echo Renaming complete!

::##############################################################################
::##  Cleanup working directory
::##############################################################################

:exit
echo:
echo:
echo:
echo Press any key to exit and clear all temporary data.

pause > nul

:: clean all temporary files
del tmp_*

:: clean temporary folder, if it is completely empty
cd %temp%
dir /b /a "batch_tmp_delete_me\*" | >nul findstr "^" && (goto info) || (rd batch_tmp_delete_me)
goto realexit

:info
echo WARNING: The folder %temp%\batch_tmp_delete_me possibly contains user data.
echo If yoou want, you can remove it manually. Press any key to exit.
pause > nul

:realexit

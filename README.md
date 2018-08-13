# windows-usbserial-rename

## Introduction:
Exchanging generic data between a micro controller and a computer is often done with a USB CDC serial interface. Whenever Windows detects a new USB serial device, it installs a generic driver automatically. Unfortunately the assigned name is also generic, making it harder to find in various programs. While it is possible to write custom drivers with custom device names, it is complicated to install them without a valid signature.

## Description:
This repro contains a single batch file (.bat) to rename any USB serial device based on the settings at the start of the file. It will automatically detect any number of devices with given VID/PID combination and update their display names. The COM port number will be appended as " (COMxx)", where xx is the detected number for the specific device. 

## Usage:
### Standard:
If you've received a variant of this file from a 3rd party it is likely that all required options have been set up for you. Just run the file as Administrator and confirm the operation with `yes` when asked. If an error occurs follow the on screen instructions.

### Developer:
The device ID, the new name and a few more options can be specified at the start of the batch file. Simply open the file with any text editor and change the variables in the `USER VARIABLES` section; batch specific programming is not required. Once you've confirmed correct operation for your device, you can set `APP_IS_DEVELOPER` to `false` and include it in your distribution. You **do not** need to include a separate license file, as a copy is embedded into the batch file, which can be displayed at runtime.
The device ID, the new name and a few more options can be specified at the start of the batch file. Simply open the file with any text editor and change the variables in the `USER VARIABLES` section; batch specific programming is not required. Once you've confirmed correct operation for your device, you can set `APP_IS_DEVELOPER` to `false` and include it in your distribution. You **DO NOT** need to include a separate license file, as a copy is embedded into the batch file, which can be displayed at runtime.

## Useful Third Party Tools/ Services:
### pid.codes:
When implementing a USB CDC serial device you can usually use a VID/PID pair provided by chip manufacture for generic use. This script however requires a unique VID/PID pair to work correctly. You can obtain a VID (with all 2^16 PIDs) for 5000$ from http://www.usb.org/developers/vendor/. Alternatively, if your project is licensed under a recognized open source license, you can get a valid pair for free from http://pid.codes.

### PopCom:
If you have multiple identically looking USB serial devices in use, it might be hard to figure out which one you just connected/disconnected. PopCom displays a popup on either event which contains the name set by the batch file, including the COM port number. Get it here: https://github.com/avishorp/PopCom/tree/master/PopCom

### USBDeview:
Getting all information about installed USB drivers can be fairly complicated. USBDeview solves this problem and displays all devices in a neat list. This is not directly related to the batch script, but helped me a lot during development. Get it here: https://www.nirsoft.net/utils/usb_devices_view.html

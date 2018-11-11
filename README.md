<h1 align="center" style="font-weight: bold; margin-top: 20px; margin-bottom: 20px;">windows-usbserial-rename</h4>

<h3 align="center" style="font-weight: bold; margin-top: 20px; margin-bottom: 20px;">Change the name of any USB serial device to a custom string.</h4>


<p align="center">
	<a href="#changelog"><img src="https://img.shields.io/github/release-pre/nqtronix/windows-usbserial-rename.svg" alt="release: NA"></a>
    <a href="https://github.com"><img src="https://img.shields.io/badge/platform-windows-blue.svg" alt="platform: github.com"></a>
	<a href="#status"><img src="https://img.shields.io/badge/status-shelved-yellowgreen.svg" alt="status: shelved"></a>
	<a href="https://github.com/nqtronix/windows-usbserial-rename/issues"><img src="https://img.shields.io/github/issues/nqtronix/windows-usbserial-rename.svg" alt="issues: NA"></a>
	<a href="#license"><img src="https://img.shields.io/github/license/nqtronix/windows-usbserial-rename.svg" alt="license: NA"></a>
</p>

<p align="center">
  <a href="#getting-started">Getting Started</a> •
  <a href="#documentation">Documentation</a> •
  <a href="#support">Need Help?</a> •
  <a href="#about">About</a> •
  <a href="#credits-and-references">Credits</a>
</p>

<br>

## Introduction
Exchanging generic data between a micro controller and a computer is often done with a USB CDC serial interface. Whenever Windows detects a new USB serial device, it installs a generic driver automatically. Unfortunately the assigned name is also generic, making it harder to find in various programs. While it is possible to write custom drivers with custom device names, it is complicated to install them without a valid signature.

**windows-usbserial-rename** contains a single batch file (.bat) to rename any USB serial device based on the settings at the start of the file. It will automatically detect any number of devices with given VID/PID combination and update their display names. The COM port number will be appended as ` (COMxx)`, where xx is the detected number for the specific device.

<br>

## Usage Example
This is how the script looks like executed:

<a href="https://github.com/nqtronix/windows-usbserial-rename"><img src="https://raw.githubusercontent.com/nqtronix/windows-usbserial-rename/master/example.png" alt="Usage Example Screenshot"></a>



<br>

## Getting Started
Using windows-usbserial-rename is super simple. Nevertheless, if you run into problems, please [ask for help](#get-help).<br>

### Step 1: Download windows-usbserial-rename
  - Clone this repository or hit [Download][git-download] and extract the .zip file.
   
### Step 2: Edit the Script (optional)
 - **open with a editor** <br>
   Right-click an the file, select "open with" your faviorite text editor. Do not double-click, this will run the script.
   
 - **change the config** <br>
   The first section contains variables for customisation

### Step 3: Run it
 - **start script**<br>
   Right-click the script and select "run as administrator". This is requires because the script changes the registry.
   
 - **confirm**<br>
   Confirm the operation by typing `yes` when asked.

<br>

## Documentation

### Usage
If you've received a variant of this file from a 3rd party it is likely that all required options have been set up for you. Just run the file as administrator and confirm the operation with `yes` when asked. If an error occurs follow the on screen instructions.

### Developer
The device ID, the new name and a few more options can be specified at the start of the batch file. Simply open the file with any text editor and change the variables in the `USER VARIABLES` section; batch specific programming is not required. Once you've confirmed correct operation for your device, you can set `APP_IS_DEVELOPER` to `false` and include it in your distribution. You **do not need** to include a separate license file, as a copy is embedded into the batch file, which can be displayed at runtime.

<br>

## Support

### Get Help

**Something doesn't work as expected?** No worries! Just open up a new issue in the [GitHub issue tracker][git-issues]. Please provide all information to reproduce your problem. If you don't have a GitHub account (and can't be bothered to create one,) you can [contact](#contact) me directly.

<br>

### Contribute

**Spotted an error?** [Open an issue][git-issues] or submit a pull request.

There is no CONTRIBUTING.md yet, sorry. Contributions will inherit the [license](#license) of this project. If you have any questions, just ask.

<br>

## About
### Status
**This project is currently classified as** <a href="https://github.com/nqtronix/git-template/blob/master/badges.md#project-status"><img src="https://img.shields.io/badge/status-shelved-yellowgreen.svg" alt="status: shelved"></a><br>
_The developers paused most activity on this project, but intend to fix critical bugs and issues. The code may not work with the most recent dependencies._

This little batch file works and does everthing I need, so for no no further development is planned.

<br>

### Changelog
This project uses [**Semantic Versioning 2.0.0**][semver.org]. During initial development (0.x.x versions) any _major_ increase is substituted with a _minor_ increase (0.1.0->0.2.0 instead of 0.1.0->1.0.0).

The message of each commit contains detailed information about the changes made. The list below is a summary about all significant improvements.

 - **1.0.1 (latest)**
   - initial release, now with updated readme

<br>

### Contact

If you haven't done so already, please check out [Get Help](#get-help) for the fastest possible help on your issue. Alternatively you can find my public email address on my [profile][git-profile].

<br>

## Credits and References

### Projects Used

 - [**pid.codes**][pid.codes]<br>
When implementing a USB CDC serial device you can usually use a VID/PID pair provided by chip manufacture for generic use. This script however requires a unique VID/PID pair to work correctly. You can obtain a VID (with all 2^16 PIDs) for 5000$ from [usb.org](service-usb-id). Alternatively, if your project is licensed under a recognized open source license, you can apply for a valid pair for free.

 - [**PopCom**][tool-popcom] - _COM Port Notification pop-up_<br>
If you have multiple identically looking USB serial devices in use, it might be hard to figure out which one you just connected/disconnected. PopCom displays a popup on either event which contains the name set by the batch file, including the COM port number. Thanks [@avishorp][at-avishorp] for this tool!

 - [**USBDeview**][tool-usbdevview]<br>
Getting all information about installed USB drivers can be fairly complicated. USBDeview solves this problem and displays all devices in a neat list. This is not directly related to the batch script, but helped me a lot during development.

 - [**git-template**][git-repo-git-template] - _A simple and clean git repository template._<br>

<br>

### Related Projects

 - none (yet)
 
Want yours to be listed here, too? Create a merge request or [**get in touch**](#get-help).

<br>

## License
This project is proudly licensed under the [MIT license][git-license].

The MIT license was chosen to give you the freedom to use this project in any way you want, while protecting all contributors from legal claims. Good code works, great code works for everyone. If this code has become a part of one of your projects, a link back to us would be highly appreciated. Thanks!


<!-- LINKS -->
<!-- in-line references: websites -->

[semver.org]:https://semver.org/
[pid.codes]:http://pid.codes


<!-- in-line references to github -->

[at-avishorp]:https://github.com/avishorp

[git-profile]:https://github.com/nqtronix
[git-download]:https://github.com/nqtronix/windows-usbserial-rename/archive/master.zip
[git-issues]:https://github.com/nqtronix/windows-usbserial-rename/issues
[git-readme]:README.md
[git-license]:LICENSE.md
[git-contribute]:CONTRIBUTING.md

[git-repo-git-template]:https://github.com/nqtronix/git-template/

[tool-popcom]:https://github.com/avishorp/PopCom
[tool-usbdevview]:https://www.nirsoft.net/utils/usb_devices_view.html
[service-usb-id]:http://www.usb.org/developers/vendor/

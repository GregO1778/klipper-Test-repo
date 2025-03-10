# [Custom build for CR-10 Smart (CRC-2405V1.2)](https://github.com/Desuuuu/klipper/discussions/74)

This build has been compled form 3 sources.
1) Klipper 3D - https://www.klipper3d.org/ https://github.com/Klipper3d/klipper
2) Klipper with DWIN/DGUS support - https://github.com/Desuuuu/klipper https://github.com/Desuuuu/DGUS-reloaded-Klipper https://github.com/Desuuuu/DGUS-reloaded-Klipper-config https://github.com/Desuuuu/DGUSPrinterMenu https://github.com/Desuuuu/klipper-macros
3) KIAUH installer - https://github.com/th33xitus/kiauh

Additional Installs:
1) Moonraker - https://github.com/Arksine/moonraker
2) Mainsail - https://github.com/mainsail-crew/mainsail
3) Fluidd - https://github.com/fluidd-core/fluidd
4) KlipperScreen - https://github.com/jordanruthe/KlipperScreen
5) OctoPrint - https://github.com/OctoPrint/OctoPrint
7) PrettyGCode - https://github.com/Kragrathea/pgcode
8) TelegramBot - https://github.com/TelegramBots/telegram.bot
9) OctoPrint-Klipper - https://github.com/maxmr/OctoPrint-Klipper
10) mjpg-streamer - https://github.com/jacksonliam/mjpg-streamer
11) ustreamer (mjpg-streamer alternative) - https://github.com/pikvm/ustreamer
12) Creality Sonic Pad - https://github.com/CrealityOfficial/Creality_Sonic_Pad https://www.creality.com/pages/download-creality-sonic-pad https://github.com/CrealityTech/sonic_pad_os

Unrelated:
1) Marlin - https://github.com/MarlinFirmware/Marlin https://github.com/MarlinFirmware/Configurations https://github.com/MarlinFirmware/MarlinDocumentation https://github.com/MarlinFirmware/AutoBuildMarlin
2) Insanity Automation - https://github.com/InsanityAutomation/Marlin https://github.com/InsanityAutomation/Configurations
3) MRISCOC (For Ender 3 v2) - https://github.com/mriscoc/Ender3V2S1 https://github.com/mriscoc/Special_Configurations
4) MarlinSim - https://github.com/p3p/MarlinSimUI

CR-10 Smart configuration files are generic however the printer.cfg has been tested and is currently in use on my own machine.
Do note that My mahine has been upgraded with the Bondtech LGXLit, Bondtech Arrow, MicroSwiss Hotend, z bar backlash spring, FYSETC Portable Input Shaper on both Y (bed) and X (extruder), adjusted strain gage to use less pressure,
 and Bed modification to add leveling screws (esintially making this comparable to teh CR-10 Smart Pro). Using BTT HDMI7 touchscreen with RaspberryPi 4 8GB.

Note that the touchscreen is still a work in progress
Welcome to the Klipper project!

[![Klipper](docs/img/klipper-logo-small.png)](https://www.klipper3d.org/)

https://www.klipper3d.org/

The Klipper firmware controls 3d-Printers. It combines the power of a
general purpose computer with one or more micro-controllers. See the
[features document](https://www.klipper3d.org/Features.html) for more
information on why you should use the Klipper software.

Start by [installing Klipper software](https://www.klipper3d.org/Installation.html).

Klipper software is Free Software. See the [license](COPYING) or read
the [documentation](https://www.klipper3d.org/Overview.html). We
depend on the generous support from our
[sponsors](https://www.klipper3d.org/Sponsors.html).

## Modifications

The scope of modifications is limited to adding support for DWIN T5UID1
touchscreens (except for the addition of a `--warn` CLI option, which sets the
logging level to WARNING).

The touchscreen feature is only available for AVR/LPC176X/STM32/SAMD
micro-controllers and it needs to be configured before compilation.

The touchscreen firmware compatible with this fork is available in
[this repository](https://github.com/Desuuuu/DGUS-reloaded-Klipper).

Example configurations are available in
[this repository](https://github.com/Desuuuu/DGUS-reloaded-Klipper-config).

Available configuration options are documented in the
[sample-t5uid1.cfg](/config/sample-t5uid1.cfg) file.




<p align="center">
  <a>
    <img src="https://raw.githubusercontent.com/th33xitus/kiauh/master/resources/screenshots/kiauh.png" alt="KIAUH logo" height="181">
    <h1 align="center">Klipper Installation And Update Helper</h1>
  </a>
</p>

<p align="center">
  A handy installation script that makes installing Klipper (and more) a breeze!
</p>

<p align="center">
  <a><img src="https://img.shields.io/github/license/th33xitus/kiauh"></a>
  <a><img src="https://img.shields.io/github/stars/th33xitus/kiauh"></a>
  <a><img src="https://img.shields.io/github/forks/th33xitus/kiauh"></a>
  <a><img src="https://img.shields.io/github/languages/top/th33xitus/kiauh?logo=gnubash&logoColor=white"></a>
  <a><img src="https://img.shields.io/github/v/tag/th33xitus/kiauh"></a>
  <br />  
  <a><img src="https://img.shields.io/github/last-commit/th33xitus/kiauh"></a>
  <a><img src="https://img.shields.io/github/contributors/th33xitus/kiauh"></a>
</p>

## **🛠️ Instructions:**

For downloading this script it is necessary to have git installed.\
If you haven't, please run `sudo apt-get install git -y` to install git first.\
After git is installed, use the following commands in the given order to download and execute the script:

For the main branch maintained my the creator:
```shell
cd ~

git clone https://github.com/th33xitus/kiauh.git

./kiauh/kiauh.sh
```

For the version included in this repo:
```shell
cd ~

git clone https://github.com/GregO1778/klipper.git

cd ./klipper
./kiauh.sh
```
**📢 Disclaimer: Usage of this script happens at your own risk!**


## **❗ Notes:**

**📋 Please see the [Changelog](docs/changelog.md) for possible important changes!**

- Tested **only** on Raspberry Pi OS Lite (Debian 10 Buster)
    - Other Debian based distributions can work
    - Reported to work on Armbian too
- During the use of this script you might be asked for your sudo password. There are several functions involved which need sudo privileges.

## **🌐 Sources & Further Information**

<table>
<tr>
<th><h3><a href="https://github.com/Klipper3d/klipper">Klipper</a></h3></th>
<th><h3><a href="https://github.com/Arksine/moonraker">Moonraker</a></h3></th>
<th><h3><a href="https://github.com/mainsail-crew/mainsail">Mainsail</a></h3></th>
</tr>
<tr>
<th><img src="https://raw.githubusercontent.com/Klipper3d/klipper/master/docs/img/klipper-logo.png" alt="Klipper Logo" height="64"></th>
<th><img src="https://avatars.githubusercontent.com/u/9563098?v=4" alt="Arksine avatar" height="64"></th>
<th><img src="https://raw.githubusercontent.com/mainsail-crew/docs/master/assets/img/logo.png" alt="Mainsail Logo" height="64"></th>
</tr>
<tr>
<th>by <a href="https://github.com/KevinOConnor">KevinOConnor</a></th>
<th>by <a href="https://github.com/Arksine">Arksine</a></th>
<th>by <a href="https://github.com/mainsail-crew">mainsail-crew</a></th>
</tr>
<tr>
<th><h3><a href="https://github.com/fluidd-core/fluidd">Fluidd</a></h3></th>
<th><h3><a href="https://github.com/jordanruthe/KlipperScreen">KlipperScreen</a></h3></th>
<th><h3><a href="https://github.com/OctoPrint/OctoPrint">OctoPrint</a></h3></th>
</tr>
<tr>
<th><img src="https://raw.githubusercontent.com/fluidd-core/fluidd/master/docs/assets/images/logo.svg" alt="Fluidd Logo" height="64"></th>
<th><img src="https://avatars.githubusercontent.com/u/31575189?v=4" alt="jordanruthe avatar" height="64"></th>
<th><img src="https://camo.githubusercontent.com/627be7fc67195b626b298af9b9677d7c58e698c67305e54324cffbe06130d4a4/68747470733a2f2f6f63746f7072696e742e6f72672f6173736574732f696d672f6c6f676f2e706e67" alt="OctoPrint Logo" height="64"></th>
</tr>
<tr>
<th>by <a href="https://github.com/fluidd-core">fluidd-core</a></th>
<th>by <a href="https://github.com/jordanruthe">jordanruthe</a></th>
<th>by <a href="https://github.com/OctoPrint">OctoPrint</a></th>
</tr>
<th><h3><a href="https://github.com/nlef/moonraker-telegram-bot">Moonraker-Telegram-Bot</a></h3></th>
<th><h3><a href="https://github.com/Kragrathea/pgcode">PrettyGCode for Klipper</a></h3></th>
<th><h3><a href="https://github.com/TheSpaghettiDetective/moonraker-obico">Obico for Klipper</a></h3></th>
<tr>
</tr>
<tr>
<th><img src="https://avatars.githubusercontent.com/u/52351624?v=4" alt="nlef avatar" height="64"></th>
<th><img src="https://avatars.githubusercontent.com/u/5917231?v=4" alt="Kragrathea avatar" height="64"></th>
<th><img src="https://avatars.githubusercontent.com/u/46323662?s=200&v=4" alt="Obico logo" height="64"></th>

</tr>
<tr>
<th>by <a href="https://github.com/nlef">nlef</a></th>
<th>by <a href="https://github.com/Kragrathea">Kragrathea</a></th>
<th>by <a href="https://github.com/TheSpaghettiDetective">Obico</a></th>
</tr>
</table>

## **Credits**

* A big thank you to [lixxbox](https://github.com/lixxbox) for that awesome KIAUH-Logo!
* Also a big thank you to everyone who supported my work with a [Ko-fi](https://ko-fi.com/th33xitus) !
* Last but not least: Thank you to all contributors and members of the Klipper Community who like and share this project!

# klipper-macros

A collection of my Klipper G-code macros.

## Usage
Copy the `macros` folder alongside your printer configuration file and edit it to add:

```
[include macros/*.cfg]
```

## Configuration
You can configure some macros using [SAVE_VARIABLE](https://github.com/KevinOConnor/klipper/blob/master/docs/G-Codes.md#save-variables) in the following way:

```
[save_variables]
filename: ~/variables.cfg

[delayed_gcode macros_initialize]
initial_duration: 1
gcode:
  INITIALIZE_VARIABLE VARIABLE=park_x VALUE=30
  INITIALIZE_VARIABLE VARIABLE=park_y VALUE=30
  INITIALIZE_VARIABLE VARIABLE=bowden_len VALUE=300
```

Here's the list of parameters you can configure:
| Name       | Default      | Description             |
|:----------:|:------------:|:-----------------------:|
| park_x     | *x_min* + 20 | Default X park position |
| park_y     | *y_min* + 20 | Default Y park position |
| bowden_len | 100          | Bowden tube length      |

## Macros
* [G27](/macros/G27.cfg)
* [G29](/macros/G29.cfg)
* [M204](/macros/M204.cfg)
* [M205](/macros/M205.cfg)
* [M600](/macros/M600.cfg)
* [M701](/macros/M701.cfg)
* [M702](/macros/M702.cfg)
* [M900](/macros/M900.cfg)
* [POWEROFF](/macros/POWEROFF.cfg)
* [NOTIFY](/macros/NOTIFY.cfg)
* [LAZY_HOME](/macros/LAZY_HOME.cfg)
* [RETRACT](/macros/RETRACT.cfg)
* [PAUSE_PARK](/macros/PAUSE_PARK.cfg)
* [PRE_START](/macros/PRE_START.cfg)
* [POST_END](/macros/POST_END.cfg)
* [WIPE_LINE](/macros/WIPE_LINE.cfg)
* [INITIALIZE_VARIABLE](/macros/INITIALIZE_VARIABLE.cfg)
* [SAVE_AT_END](/macros/SAVE_AT_END.cfg) by [Makoto](https://klipper.info/macro-examples-1/makotos-conditional-config-saving)
* [SAVE_IF_SET](/macros/SAVE_IF_SET.cfg) by [Makoto](https://klipper.info/macro-examples-1/makotos-conditional-config-saving)


# __Firmware Helper__

https://github.com/CrealityOfficial/Creality_Sonic_Pad_Firmware.git

# __Faq  Helper__

https://www.creality.com/pages/faq?spm=..page_2450731.header_1.1&spm_prev=..page_1934481.products_display_1.1

# __Os  Helper__

https://github.com/CrealityTech/sonic_pad_os

# __Tip for use:__

When the configuration file is copied to the USB stick and boot through the Sonic Screen custom model, the mcu connection serial address will be automatically changed to the corresponding USB interface mapping. If you manually overwrite the configuration file with the Fluidd configuration file option, you need to modify the mcu connection serial address format to: serial: /dev/serial/by-id/usb_serial_1 (if the machine is connected to USB port 2, then change it to serial: /dev/serial/by- id/usb_serial_2 and so on).
 
# __User defined firmware compilation guide__

Using Linux subsystem under Windows 10 64-bit
	Download and install VirtualBox
Download VirtualBox from www.VirtualBox.org
	Download Ubuntu 18.04.LTS
Download Ubuntu 18.04.LTS from www.ubuntu.com/download
	Create a new virtual machine and install Ubuntu system
1.	Open VirtuslBox and create a new virtual machine
2.	Select destination folder、Enter a name，Type: Select Linux、Version: Select Ubuntu（64-bit）
3.	Resize memory to 4096MB
4.	Create a virtual hard disk
5.	Select VDI
6.	Select dynamic allocation
7.	Resize the virtual hard disk to 25GB
8.	General Settings – Advanced，Change the shared clipboard and the drag and drop to bidirectional
9.	System settings - adjust the boot order to optical drive - hard disk - floppy drive
10.	Storage Settings--IDE--Select Downloaded Ubuntu 18.04.6LTS
11.	SATA--tick Use Host I/0 Cache
12.	Network Settings - Advanced - Make sure the network is connected
13.	User Interface -Device-Tick Insert Guest additions CD image
14.	Start the virtual machine after confirmation
15.	Install Ubuntu
	System upgrade and install git 
1.	run command  sudo apt update （list all updatable software）
2.	run command  sudo apt upgrade  （upgrade the package）
3.	Devices -- Install Insert Guest additions CD image
4.	run command  sudo apt-get install git（install git）
5.	Restart the system
	Download Klipper firmware
1.	run command cd ~ (switch the working directory to the home directory)
2.	run command git clone  
   https://github.com/CrealityOfficial/Creality_Sonic_Pad_Project.git
	Configure printer firmware
1.	Open the file manager-Klipper folder-scripts folder-Right click-open in terminal
2.	run command ls (confirm that the content in the current directory is consistent with that in the folder)
3.	run command ./install-ubuntu-18.04.sh（install ubuntu）
4.	run command cd .. (switch to the upper directory)
5.	run command ls (confirm that the content in the current directory is consistent with that in the folder)
6.	run command make menuconfig (configure the printer motherboard)
7.	Select the Micro-controller Architecture、Processor model、Bootloader Offset、Clock Reference、Communication interface etc. parameters
8.	After the parameter configuration is completed, press "Q" to save，Press "Y" to confirm
9.	run command make （generate firmware）
	Upgrade printer firmware via SD/TF card
1.	Create a new "ubuntu_sharing" on the computer disk
2.	Open VirtualBox--Settings--Shared Folders，Add a shared folder (tick auto mount)，Mount point type "/sharings"
3.	Copy the klipper.bin file just generated to the sharings folder
4.	Copy klipper.bin in the ubuntu_sharing folder of the computer disk to the TF/SD
	Upgrade printer firmware via USB
(The motherboard has no Bootloader and does not support SD card upgrades)
Please use a USB cable to connect the printer to the computer 
where the virtual machine is located. Please keep the connection 
during the firmware upgrade process
1.	Refer to the previous video to enter the configuration  motherboardinterface、Select the Micro-controller Architecture、 Processor model、Clock Reference、Communication interface etc. parameters
2.	After the parameter configuration is completed, press "Q" to save，Press "Y" to confirm
3.	run command make （generate firmware）
4.	Device--USB--Tick the USB option for connection to the printer
5.	run command ls /dev/tty*(Confirm that /dev/ttyUSB0 appears in the directory)
6.	run command sudo avrdude -cwiring -patmega2560 -P/dev/ttyUSB0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i（Transfer the klipper firmware to the printer for upgrade，Note the space before the "-" in the command）

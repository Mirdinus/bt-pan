# bt-pan
Automation of backup bluetooth PAN (mainly for Raspberry Pi)

## Original work
__Original work done by @logan-gunthorpe over at [Stack Exchange](https://raspberrypi.stackexchange.com/questions/29504/how-can-i-set-up-a-bluetooth-pan-connection-with-a-raspberry-pi-and-an-ipod#71587)__

# Installation

## Standart way
  * `git clone https://github.com/Mirdinus/bt-pan`
  * `cd github.com bt-pan`
  * `bash provision.sh`

## One-liner
  * `sh -c "$(curl -fsSL https://raw.github.com/Mirdinus/bt-pan/master/provision.sh)"`

## Issues with non-standard distros
### Bluetooth is not working
  Check if _/boot/config.txt contains_ `doverlay=miniuart-bt` [raspberry forum](https://forums.raspberrypi.com/viewtopic.php?p=1947781#p1947781)

  Diet Pi - [issue #2607](https://github.com/MichaIng/DietPi/issues/2607#issuecomment-470528403)
  * Use dietpi script from /boot/dietpi directory
  * dietpi-set_hardware bluetooth enable


_P.S. I'm just doing a lot of rebuilds and bt-pan is my prefered way of getting a wireless backup connection to the RPi_

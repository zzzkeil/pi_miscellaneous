#!/bin/bash

#### install stuff
sudo apt update && sudo apt upgrade -y
sudo apt install --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox chromium-browser -y
echo
echo

#### choose site
read -p "Welche Internetseite soll aufgerufen werden ? >>>>  " -e -i https://zeroaim.de showurl
echo
echo

#### openbox config
sudo mv /etc/xdg/openbox/autostart /etc/xdg/openbox/autostart.orig
echo '
#Disable screen saver / screen blanking / power management
xset s off
xset s noblank
xset -dpms

#Exit X server with CTRL-ATL-Backspace
setxkbmap -option terminate:ctrl_alt_bksp

#Chromium incognito kiosk mode
sed -i "'"s/"exited_cleanly":false/"exited_cleanly":true/"'" ~/.config/chromium/"'"Local State"'"
sed -i "'"s/"exited_cleanly":false/"exited_cleanly":true/; s/"exit_type":"[^"]\+"/"exit_type":"Normal"/"'" ~/.config/chromium/Default/Preferences
chromium-browser --incognito --disable-infobars --kiosk "'"$showurl"'"
 ' | sudo tee --append /etc/xdg/openbox/autostart > /dev/null
echo 
echo

#### slightly more secure user pi
sudo mv /etc/sudoers.d/010_pi-nopasswd /etc/sudoers.d/010_pi-nopasswd.orig
echo "
pi ALL=(ALL) PASSWD: ALL
" | sudo tee --append /etc/sudoers.d/010_pi-nopasswd > /dev/null
echo
echo

#### autostart openbox/chrome
sudo cp /etc/profile /etc/profile.orig
echo "startx -- -nocursor"  | sudo tee --append /etc/profile > /dev/null
echo
echo

#### autologing pi without raspi-config
# next version

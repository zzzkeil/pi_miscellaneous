#!/bin/bash

 
read -p "Just change the website?  [yn]" -n 1 -r answer1
echo "When you run this script for the first time, reply with n"
if [[ $answer1 = y ]]; then
read -p "Which website should be opened : " -e -i https://zeroaim.de showurl
sudo mv /etc/xdg/openbox/autostart /etc/xdg/openbox/autostart.orig
echo "
#Disable screen saver / screen blanking / power management
xset s off
xset s noblank
xset -dpms

#Exit X server with CTRL-ATL-Backspace
setxkbmap -option terminate:ctrl_alt_bksp

#Chromium incognito kiosk mode
sed -i '"'s/"exited_cleanly":false/"exited_cleanly":true/'"' ~/.config/chromium/'"'Local State'"'
sed -i '"'s/"exited_cleanly":false/"exited_cleanly":true/; s/"exit_type":"[^"]\+"/"exit_type":"Normal"/'"' ~/.config/chromium/Default/Preferences
chromium-browser --incognito --disable-infobars --hide-scrollbars --kiosk "'"'""${showurl}""'"'"
 " | sudo tee --append /etc/xdg/openbox/autostart > /dev/null
 exit 1
else
read -p "Just change touchscreen orientation to normal?  [yn]" -n 1 -r answer2
echo "When you run this script for the first time, reply with n"
if [[ $answer2 = y ]]; then
sudo rm /usr/share/X11/xorg.conf.d/45-evdev.conf
 exit 1
else
read -p "Change touchscreen orientation to 90 degrees?  [yn]" -n 1 -r answer22
echo "When you run this script for the first time, reply with n"
echo "When you set this, add this display_hdmi_rotate=1  !manually! to /boot/config.txt"
if [[ $answer22 = y ]]; then
sudo rm /usr/share/X11/xorg.conf.d/45-evdev.conf
echo '
Section "InputClass"
        Identifier "evdev pointer catchall"
        MatchIsPointer "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev keyboard catchall"
        MatchIsKeyboard "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev tablet catchall"
        MatchIsTablet "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev touchscreen catchall"
        MatchIsTouchscreen "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
        Option "SwapAxes" "true"
        Option "InvertX" "false"
        Option "InvertY" "true"
EndSection
' | sudo tee --append /usr/share/X11/xorg.conf.d/45-evdev.conf > /dev/null
exit 1
fi
fi

#### choose site
read -p "Which website should be opened :  " -e -i https://zeroaim.de showurl
echo
echo

#### install stuff
read -p "apt update needed ?  [yn]" -n 1 -r answer3
if [[ $answer3 = y ]]; then
sudo apt update && sudo apt upgrade -y
fi
sudo apt install --no-install-recommends xserver-xorg x11-xserver-utils xserver-xorg-input-evdev xinit openbox chromium-browser -y
echo
echo

#### openbox config
sudo mv /etc/xdg/openbox/autostart /etc/xdg/openbox/autostart.orig
echo "
#Disable screen saver / screen blanking / power management
xset s off
xset s noblank
xset -dpms

#Exit X server with CTRL-ATL-Backspace
setxkbmap -option terminate:ctrl_alt_bksp

#Chromium incognito kiosk mode
sed -i '"'s/"exited_cleanly":false/"exited_cleanly":true/'"' ~/.config/chromium/'"'Local State'"'
sed -i '"'s/"exited_cleanly":false/"exited_cleanly":true/; s/"exit_type":"[^"]\+"/"exit_type":"Normal"/'"' ~/.config/chromium/Default/Preferences
chromium-browser --incognito --disable-infobars --hide-scrollbars --kiosk "'"'""${showurl}""'"'"
 " | sudo tee --append /etc/xdg/openbox/autostart > /dev/null
echo 
echo

#### change touchscreen orientation
read -p "Change touchscreen orientation 90 degrees ?  [yn]" -n 1 -r answer4
echo "When you set this, add this display_hdmi_rotate=1  !manually! to /boot/config.txt"
if [[ $answer4 = y ]]; then
sudo mv /usr/share/X11/xorg.conf.d/10-evdev.conf /usr/share/X11/xorg.conf.d/10-evdev.conf.orig
sudo rm /usr/share/X11/xorg.conf.d/10-evdev.conf
echo '
Section "InputClass"
        Identifier "evdev pointer catchall"
        MatchIsPointer "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev keyboard catchall"
        MatchIsKeyboard "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev tablet catchall"
        MatchIsTablet "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev touchscreen catchall"
        MatchIsTouchscreen "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
        Option "SwapAxes" "true"
        Option "InvertX" "false"
        Option "InvertY" "true"
EndSection
' | | sudo tee --append /usr/share/X11/xorg.conf.d/45-evdev.conf > /dev/null
fi
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
#### autostart question temp
read -p "Setup autostart ?  [yn]" -n 1 -r answer5
if [[ $answer5 = y ]]; then
sudo cp /etc/profile /etc/profile.orig
echo "startx -- -nocursor"  | sudo tee --append /etc/profile > /dev/null
fi
echo
echo


#### todo 4  next versions
## autologing pi without raspi-config
## check if autostart arealy set and skip
## change / vars for screen oriantations
## set file to check if the script runs the first time
##

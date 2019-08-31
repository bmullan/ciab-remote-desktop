#!/bin/bash

#========================================================================================================================
# mk-cn1-environment.sh 
#
# by brian mullan (bmullan.mail@gmail.com)
#
# Purpose:
#
# Install the apt tool to speed up apt's thru multiple threads/connections to the repositories
# Install a local Ubuntu-Mate Desktop Environment (DE) into a VM or an LXC container
# Install misc useful apps/tools for future users of this DE container
#
# Installation Notes:
#
# This will take 10-20 minutes depending on speed of the host PC/server
# 
#
#========================================================================================================================
# Copyright (c) 2016-2018 Brian Mullan
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#========================================================================================================================

#
#
#

clear

echo
echo
echo
read -p "Press any key to install the Ubuntu-MATE Desktop Environment into LXC container named cn1..."
echo
echo
echo
#
#

PULSE_VER="11.1"

# make sure apt is installed
sudo apt-get install apt -y

#-----------------------------------------------------------------------------------------------------------------
# NOTE: all of the following script will be executed in the LXC containers created not on the HOST
#-----------------------------------------------------------------------------------------------------------------

# NOTE:  the setup-lxd.sh script will have passed a UserID parameter to this script we need to save that for use later

userID=$1

sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y

#==================================================================================================
# Install prereqs for compiling xrdp... in case needed sometime in future to build xrdp from source

sudo apt install libx11-dev libxfixes-dev libssl-dev libpam0g-dev libtool libjpeg-dev -y
sudo apt install flex bison gettext autoconf libxml-parser-perl libfuse-dev xsltproc libxrandr-dev python-libxml2 -y
sudo apt install nasm xserver-xorg-dev fuse git -y

#======================================================================================================

#Install miscellaneous

sudo apt install yad unzip openbox net-tools pulseaudio pulseaudio-module-zeroconf alsa-base alsa-utils linux-sound-base -y
sudo apt install gstreamer1.0-pulseaudio gstreamer1.0-alsa libpulse-dev libvorbis-dev -y

echo "Installing Ubuntu-MATE desktop environment as default for Guacamole RDP User to work with."
echo
echo "you can change this to xfce4 (ie xubuntu) by changing just 2 lines of code in the mk-cn1-environment.sh script."

sudo apt install lightdm ubuntu-mate-core ubuntu-mate-desktop -y

echo
echo
echo "Desktop Install Done"
echo
echo "Configuring the Xsession file default desktop environment to make ALL future Users default xsession to be UBUNTU-MATE..." 
echo
echo

sudo update-alternatives --set x-session-manager /usr/bin/mate-session

#===========================================================================================================
# Note:  if you wanted to use XFCE4 desktop (ie xubuntu desktop) instead of MATE you would use the following 
#        lines instead of the above.
#===========================================================================================================

# sudo apt install lightdm xubuntu-desktop -y
# sudo update-alternatives --set x-session-manager /usr/bin/xfce4-session

#===========================================================================================================
# Note:  if you wanted to use the Budgie desktop instead of MATE you would use the following 
#        line instead of the above.
#===========================================================================================================

# sudo apt install lightdm ubuntu-budgie-desktop -y

#-----------------------------------------------------------------------------------------------------------
#        For the Budgie Desktop Session to launch correctly with an XRDP conection you will also be required
#        to make a small edit of the /etc/xrdp/sesman.ini file.  
#
#        Comment out the last 2 lines of /etc/xrdp/sesman.ini and add the budgie-desktop line as follows:
#
#        # test -x /etc/X11/Xsession && exec /etc/X11/Xsession
#        # exec /bin/sh /etc/X11/Xsession
#        budgie-desktop


#======================================================================
# "Install misc useful sw apps/tools for the future users..."
#
# "gdebi - to support cli .DEB installs (if a sudo user)"
# "nano - my favorite quick/easy cli text editor"
# "firefox - the browser obviously"
# "terminator - my favorite 'multi-window' Terminal program"
# "synaptic - so future sudo users can manage sw apps easier"
#======================================================================

sudo apt install git openssh-server gdebi nano terminator synaptic wget curl ufw network-manager gedit avahi-daemon -y

# enable ufw

sudo ufw enable

#==============================================
# open certain ports on the ciab-desktop server

sudo ufw allow 22          # ssh
sudo ufw allow 8080        # http
sudo ufw allow https       
sudo ufw allow 3389        # rdp
sudo ufw allow 4822        # guacd
sudo ufw allow 5353        # avahi

#============================================================================================
# Install xrdp v0.9.9.1 using Thiago Martin's PPA
# source: https://launchpad.net/~martinx/+archive/ubuntu/xrdp-next?field.series_filter=bionic


pushd  .

sudo add-apt-repository ppa:martinx/xrdp-next -y

sleep 5

sudo apt install xorg-video-abi-24 xrdp xorgxrdp xrdp-pulseaudio-installer -y

#=======================================================================================================
# in /etc/sesman.ini change the default fusemount name 
# from
#     FuseMountName=thinclient_drives
# to
#     FuseMountName=ciab-drive
#
# This will force xrdp to create the FUSE Desktop folder used for uploads/downloads from
# the client to the remote desktop to become named 'ciab-drive' instead of thinclient_drives

sudo sed -i 's/FuseMountName=thinclient_drives/FuseMountName=ciab-drive/' /etc/xrdp/sesman.ini

#==============================================================
# Change XRDP login screen to reflect CIAB Remote Desktop title

sudo sed -i 's/#ls_title=My Login Title/ls_title=CIAB Remote Desktop/' /etc/xrdp/xrdp.ini

#=========================================================================
# next compile/create the latest version of Pulseaudio and then install it

cd /tmp
sudo apt source pulseaudio

cd /tmp/pulseaudio-${PULSE_VER}
sudo ./configure

cd /usr/src/xrdp-pulseaudio-installer
sudo make PULSE_DIR="/tmp/pulseaudio-${PULSE_VER}"

# finally install the 2 pulseaudio .so modules for us so xrdp can use them
sudo install -t "/var/lib/xrdp-pulseaudio-installer" -D -m 644 *.so

popd


#=================================================================================================
# change browsers to chromium-browser by installing it & removing firefox.  
# we do this because chromium is the basis of Chrome has been shown to have the better performance 
# with Guacamole

# NOTE: for some reason we have to install flashplugin-installer in the container first before
#       installing adobe-flashplugin.   There MUST be something flashplugin-installer installs
#       or changes that adobe-flashplugin doesn't because installing adobe-flashplugin alone
#       causes the browser to just spin when for instance you try to play a youtube video
#          Also, note that installing adobe-flashplugin will remove flashplugin-installer but
#       I guess it doesn't remove whatever this critical setting is  ???? go figure ???

sudo apt install flashplugin-installer -y
sudo apt install chromium-browser -y
sudo apt remove flashplugin-installer firefox -y
sudo apt install adobe-flashplugin adobe-flash-properties-gtk -y

#==============================================================================================================================================
# in order for all new users added to this server via sudo adduser xxx in the future we need to change the /etc/adduser.conf file
# to set /etc/adduser.conf to add all new users accounts created to the audio/pulse/pulse-access groups
#
# To do this we need to change the following 2 lines in adduser.conf.
#
# The following line needs to be first be uncommented & also changed to "include" the groups we want the user added to
##EXTRA_GROUPS="dialout cdrom floppy audio video plugdev users"
# and 
# The following line just needs to be uncommented so the EXTRA_GROUPS option above will be default behavior for adding new, non-system users
##ADD_EXTRA_GROUPS=1
#
# make the 1st change
sudo sed -i 's/#EXTRA_GROUPS="dialout cdrom floppy audio video plugdev users"/EXTRA_GROUPS="audio pulse pulse-access"/' /etc/adduser.conf
# make the 2nd change
sudo sed -i 's/#ADD_EXTRA_GROUPS=1/ADD_EXTRA_GROUPS=1/' /etc/adduser.conf

#=======================================
# Clean up some things before exiting...

sudo apt autoremove -y

#
#
# "Mate Desktop Environment installation in CN1 is finished.."
#
# "*** Remember to create some UserID's in the LXD/LXC container CN1 for your CIAB Desktop users ! "
#
#
#

clear

exit 0



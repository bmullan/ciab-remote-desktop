#!/bin/bash

# Check if user is root or sudo ... if so... then exit and tell user to run as non-sudo/root.

echo
echo
if [ $(id -u) = 0 ]; then echo "Do NOT run this script SUDO or ROOT... please run as your normal UserID !"; exit 1 ; fi
echo
echo

#==============================================================================================================================================
# ciab-remote-desktop by Brian Mullan, Raleigh NC USA, bmullan.mail@gmail.com
#
# ciab-desktop is a script which installs/integrates several technologies to provide a HTML5 browser based remote desktop capability TO a 
# Linux server.
#
# ANY device which has an HTML5 capable browser should be able to login after installation & initial connection/user setup.
#
# Benefit:  Since the User will be connected to a Remote Desktop ... it no longer matters how fast a cpu, how much memory or disk storage
#           the User's own local machine has (chromebook, tablet, phone or old PC)... everything is running virtually for them and you
#           can install ciab-desktop on even the most powerful Cloud servers with many cpu core, terabytes of memory & storage.
#
# This script can be run on any Ubuntu cloud/local server, pc, or even on a VM (KVM or VirtualBox) and also in an LXC container.
#
# Technologies involved include:  guacamole, xrdp, x11rdp, tomcat8, mysql, nginx, LXD/LXC and ubuntu
#
# Note:  you should run this setup-ciab.sh script as from "some" user (re user you created) home directory
#        When done it will have placed several tar.gz files as well as several new directories in that home directory.  You should be
#        able to safely delete any/all of those new files/directories after installation.
#
#
#=============================================================================================================================================
# Copyright (c) 2016 Brian Mullan
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
#==============================================================================================================================================

PULSE_VER="11.1"

#----------------------------------------------------------------------------------------------------------------------------------------------
# IMPORTANT:
# set "files" to the location where installation files were UNTarred. If it was not in /opt/ciab then change to point to where you put them

files=/opt/ciab

cd $files

# install apt
sudo apt-get install apt -y

# From here on we can use apt to update Everything
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y

#-------------------------------------------------------------------------------------------------------------------
# make sure the lxd snap package is installed so we are using a latest version of lxd which as of 10/4/2018 was v3.5
 
./setup-lxd.sh

cd $files

#=====================
# setup the containers

./setup-containers.sh

cd $files

#===================================================================================================
# create a /opt/ciab directory in ciab-guac and give ownership to whoever this installer's UserID is
# as we used this UserID to create initial adm/sudo userID in the containers

lxc exec ciab-guac -- /bin/bash -c "mkdir /opt/ciab"
lxc exec ciab-guac -- /bin/bash -c "chown $USER:$USER /opt/ciab"

# push the setup-guacamole and setup-nginx scripts into the ciab-guac container'a /opt/ciab

lxc file push /opt/ciab/setup-guacamole.sh ciab-guac/opt/ciab/
lxc file push /opt/ciab/setup-nginx.sh ciab-guac/opt/ciab/

# now execute those 2 scripts.  since they both need to be executed as sudo/root
# this works fine using "lxc exec"

lxc exec ciab-guac -- /bin/bash -c "/opt/ciab/setup-guacamole.sh"
lxc exec ciab-guac -- /bin/bash -c "/opt/ciab/setup-nginx.sh"

cd $files

clear
echo
echo
echo "CIAB Remote Desktop Installation complete."
echo
echo "Two last steps: "
echo
echo "You need to edit the file 'setup-proxy.sh' and set the variable that ID"
echo "the Host IP address."
echo 
echo "This is done so incoming HTTPS traffic on the HOST gets proxy'd into the ciab-guac"
echo "container for handling by guacamole!"
echo
echo "After making these changes, you need to execute setup-proxy.sh but NOT as sudo/root."
echo
read -p "Press any key to finish ..."
echo
echo


exit 0










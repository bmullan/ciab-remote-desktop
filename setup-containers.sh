#!/bin/bash

# NOTE:  This script should NOT be executed as SUDO or ROOT .. but as a normal UserID

# Check if user is root or sudo ... if so... then exit and tell user.

echo
echo
if [ $(id -u) = 0 ]; then echo "Do NOT run this script SUDO or ROOT... please run as your normal UserID !"; exit 1 ; fi
echo
echo

#================================================================================================================
# setup-containers.sh 
#
# by brian mullan (bmullan.mail@gmail.com)
#
# Purpose:
#
#   use LXD/LXC instead of traditional LXC to create LXC containers on a Host for use with CIAB-DESKTOP
#
#   for more guidance on LXD see:   https://linuxcontainers.org/lxd/getting-started-cli/
# 
# IMPORTANT NOTE:  run this script as your normal non-sudo userID do NOT run as SUDO !!
#
# Basic LXD/LXC commands...
#
# To register locally the Default LXD/LXC repository of Template "images" for pre-built LXC rootfs which include
# CentOS, Ubuntu, Debian, Fedora, OpenSuse, Oracle etc
#
# NOTE:  this only needs to be done once...
#
#           $ lxc remote add images images.linuxcontainers.org
#
# To list all available LXD/LXC images you can use after doing the above "add" command (its a long list so you
# may want to redirect it to a file so you can look at it later:
#
#           $ lxc image list images:
#
# To launch (create & start) an LXD/LXC container pick the image/architecture/distro you want to use:
#
# examples:
#    to launch a CentOS v7 x64 bit container:
#           $ lxc launch images:centos/7/amd64 my_centos_cn
#         or
#    to launch an Ubuntu bionic (re 15.10) x64 bit container:
#           $ lxc launch images:ubuntu/bionic/amd64 my_ubuntu_cn
#
# To get all info about an existing container:
#
#           $ lxc info cn_name
#
# To get a shell inside the container, or to run any other command that you want, you may do:
#
#           $ lxc exec cn_name /bin/bash
#
# To directly pull or push files from/to the container with the following.   This is particularly useful
# when you want to copy a Bash or Python script to an LXD/LXC container for later execution.
#
#           $ lxc file pull cn_name/path/to/file .
#          or
#           $ lxc file push /path/to/file cn_name/
#
# To run a command inside an LXD/LXC container without logging into it first use:
#
#      example - to run apt-get update inside the container:
#
#           $ lxc exec cn_name -- apt-get update
#
# To stop an LXD/LXC container:
#
#           $ lxc stop cn_name
#
# To delete an LXD/LXC container:
#
#           $ lxc delete cn_name
#
#
#
#=============================================================================================================
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
#=============================================================================================================

# set location where the installation files were placed when they were UNTarred.  If you put them somewhere 
# else then change the following to point to that directory

files=/opt/ciab/


#-------------------------------------------------------------------------------------------------------------
# Assumptions:
# 1) you are running this script on the same HOST where we previously installed ciab-desktop 
#    since when we did that all of the ciab-desktop bundled bash scripts etc were all copied onto that machine
#    or vm etc.
# 2) you are in a terminal in the directory on the Host that contains all of the ciab-desktop scripts etc when
#    this setup-containers.sh script is run
#-------------------------------------------------------------------------------------------------------------

clear

echo
echo
echo "------------------------------------------------------------------------------------"
echo "Creating our LXD/LXC container and adding the User/Installer as a SUDO privileged"
echo "User Account in the container.  We are naming our container CN1"
echo "------------------------------------------------------------------------------------"
echo
echo
read -p "Press any key to continue..."
echo
echo

#================================================================
# This will create an Ubuntu 18.04 LXC Container and name it cn1.

lxc launch images:ubuntu/bionic/amd64 cn1 

#====================================================================================
# replace the minimal container sources.list with a full 18.04 sources.list that also
# includes source modules so we can later build xrdp's pulseaudio .so modules

lxc exec cn1 -- /bin/bash -c "rm /etc/apt/sources.list"
lxc file push /opt/ciab/sources.list cn1/etc/apt/
sleep 4
lxc exec cn1 -- /bin/bash -c "apt-get update"

#=============================================================
# set LXC container CN1 to autostart when the Host is rebooted

lxc config set cn1 boot.autostart 1


#---------------------------------------------------------------------------------------------------------------
# After the CN1 container is started we begin by first creating a new User Account using whoever is running this
# install script as the UserID.  We'll also make the new User in the container a privileged user (re sudo priv)
#---------------------------------------------------------------------------------------------------------------

# create the new User in the cn1 container

clear

echo
echo
echo "--------------------------------------------------------------------------------------"
echo "Creating the User/Installer's account in Container CN1"
echo
echo "As normal when doing 'sudo adduser a_newID' you will be prompted to enter the new user"
echo "Password (twice) and then the User Name for the Acct, then some misc info."
echo "--------------------------------------------------------------------------------------"
echo
echo
read -p "Press any key to do this now for Container CN1..."
echo
echo

lxc exec cn1 -- adduser $USER

# set the above userIDs to have SUDO privileges in both cn1 (so they can be an admin in them)
 
lxc exec cn1 -- adduser $USER adm
lxc exec cn1 -- adduser $USER sudo

#------------------------------------------------------------------------------------------
# Next pushing the appropriate script to its now running container.
#
# each bash script that we will use will pre-install the same general tools I find useful:
#      - terminator, gdebi, nano, apt-fast, synaptic
#      - openssh-server, firefox, git, wget, curl
#
# to facilitate this we have a prebuilt bash script mk-cn1-environment.ss
#-----------------------------------------------------------------------------------------

cd $files

# push our script mk-cn1-environment.sh to the CN1 container.  This will be used to create the desktop environment
# in the container later

lxc file push ./mk-cn1-environment.sh cn1/home/$USER/


# copy our CIAB Desktop logo to the container & we will move it to the right directory later when
# the script mk-cn1-environments.sh runs.  The script runs "inside"
# the LXC containers so at that time the script can easily move the ciab-logo.bmp
# file to the right directory in the container (directory - /usr/local/share/xrdp/)

# lxc file push ./ciab-logo.bmp cn1/home/$USER/

#-------------------------------------------------------------------------------------------------------------------------
# Finally, execute the script in the CN1 container designed to install a complete Desktop environment so gets installed.
#
# step 1 - make sure all bash scripts we pushed are executable & owned by the $USER (current installer UserID)
# step 2 - execute the mk-cnX-environment.sh file in each container & let it do its job of installing a desktop
#          environment in each container

# make sure bash scripts we pushed are executable

# on cn1
lxc exec cn1 -- /bin/bash -c "chmod +x /home/$USER/*.sh"

# fix ownership of files we pushed

# on cn1
lxc exec cn1 -- /bin/bash -c "chown $USER:$USER /home/$USER/*.sh"

#================================================================================================
# Since in the container we do not install guacamole we need to push the guacamole freerdp .so
# files into the container so when a user via their browser uses guacamole to run a desktop in
# a container.. those guac*.so files will be found when the container boots and guac/xrdp/freedp
# will all process sound/audio correctly.

# 1st make sure the /usr/local/lib/freerdp directory exists in the container
# so we can put the guac*.so files there

lxc exec cn1 -- /bin/bash -c "mkdir /usr/local/lib/freerdp"


# finally create the Symbolic LINK between guacamole freerdp driver and freerdp driver

lxc exec cn1 -- /bin/bash -c "mkdir /usr/lib/x86_64-linux-gnu/freerdp/"
lxc exec cn1 -- /bin/bash -c "ln -s /usr/local/lib/freerdp/guac*.so /usr/lib/x86_64-linux-gnu/freerdp/"

#--------------------------------------------------------------------------------------------
# make sure the Installing user is part of all the right Pulseaudio groups on the Host/Server

sudo adduser $USER audio
sudo adduser $USER pulse
sudo adduser $USER pulse-access


#---------------------------------------------------------------------------------------------------------
# the next step installs the Desktop environment in the CN1 container.  This will take a while (5-10 min).

clear

echo
echo
echo "Installing Ubuntu-MATE desktop into container cn1..."
echo
echo

# note: we pass $USER to the mk-cn1-environment.sh script so it can use it also
lxc exec cn1 -- /bin/bash -c "/home/$USER/mk-cn1-environment.sh $USER" 

# Now because of an apport bug that causes recurring error msgs to pop up on each login let's
# disable apport on host and cn1

# on host
sudo sed -i 's/enabled=1/enabled=0/' /etc/default/apport

# in the container disable apport so it doesn't bug users with bogus apport msgs

lxc exec cn1 -- /bin/bash -c "sed -i 's/enabled=1/enabled=0/' /etc/default/apport"

#========================================================================================
# Next we are going to use the cn1 container to clone a container we will call ciab-guac.
# The container ciab-guac will later have additional software installed including:
#
# - guacamole
# - tomcat8
# - nginx
# - etc.
#
# all of which will create a guacamole server in ciab-guac & cn1 will be another desktop
# connection that the guacadmin can assign to "users" of the ciab service.
# note: cn1 could be copied N times as a base desktop container 
#========================================================================================


lxc stop cn1
lxc copy cn1 ciab-guac

echo
echo "Restarting containers ciab-guac and cn1..."
echo
lxc start ciab-guac
lxc start cn1

echo

# finally create the Symbolic LINK for freerdp to guacamole freerdp sound driver
lxc exec ciab-guac -- /bin/bash -c "mkdir /usr/lib/x86_64-linux-gnu/freerdp/"
lxc exec ciab-guac -- /bin/bash -c "ln -s /usr/local/lib/freerdp/guac*.so /usr/lib/x86_64-linux-gnu/freerdp/"

# lets list the LXC containers just to check 

clear

echo
echo " Check to see if ciab-guac and cn1 rebooted...and restarted okay."
echo
echo " When the listing of LXD/LXC containers appears write down the IP address of ciab-guac and cn1.. "
echo
echo " You will need those IP addresses later when you first login to Guacamole and configure"
echo " 'connections' to CN1 so users can access them and the Desktop Environments."
echo

# wait 15 seconds for LXC container to start back up then list them for the User

sleep 15
lxc list

echo
echo
read -p "Press any key to continue..."
clear

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

clear

exit 0




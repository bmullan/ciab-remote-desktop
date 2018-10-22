#!/bin/bash

clear

#================================================================================================================
# setup-lxd.sh
#
# by brian mullan (bmullan.mail@gmail.com)
#
# Purpose:
#
#   This script will install LXD onto this Host/server/VM/lxc container
# 
# IMPORTANT NOTE:  run this script as your normal non-sudo userID do NOT run as SUDO !!
#
#
#================================================================================================================
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
#
# All Guacamole Source Code is Apache License, Version 2.0.
#================================================================================================================

# set location where the installation files were placed when they were UNTarred.  If you put them somewhere 
# else then change the following to point to that directory

files=/opt/ciab/

#-------------------------------------------------------------------------------------------------------------
# Assumptions:
# 1) you are running this script from /opt/ciab on the same HOST where you installed the ciab installation
#    scripts
# 2) you run this script (setup-ciab.sh) as sudo/root
#-------------------------------------------------------------------------------------------------------------

sudo apt-get install apt 
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y

echo
echo
echo "---------------------------------------------------------------------------------"
echo "Installing LXD/LXC to support orchestration/management/use of LXC containers both"
echo "on remote or local Servers/Hosts!"
echo
echo "When the following installs LXD you will be presented with 11-12 screens/forms"
echo "concerning IPv4, DHCP, and IPv6 addressing for LXD on your system."
echo
echo "The 5th screen/form is titled CONFIGURING LXD but is where it asks for the IP"
echo "address to use for LXD.   This will by default be some random 10.x.x.x private IP"
echo "network address."
echo
echo "You can accept the default it provides or change it to something like 10.0.3.1"
echo "which is the traditional IP of the predecessor LXC lxcbr0 bridge that lxdbr0"
echo "replaces."
echo "---------------------------------------------------------------------------------"
echo
echo
read -p "Press any key to continue..."
echo
echo

#=========================================================================================
# On ubuntu 18.04 LXD comes pre-installed but we will uninstall/reinstall lxd to make sure

sudo apt purge lxd lxd-client -y

#=========================
# install LXD SNAP package

sudo snap install lxd
sudo lxd init

# before we start creating containers we need to complete 2 more steps in the LXD setup/configuration

clear

echo "********************************************************************************************************"
echo
echo "Next, please run the script... "
echo 
echo "         $/opt/ciab/setup-containers.sh"
echo
echo
echo
read -p "Press any key to continue..."
echo
echo


#=============================================================================================================
# make sure the UserID installing this is a member of the LXD group before we execute the newgrp command
# 
# IMPORTANT NOTE:  Due to the nature of the "newgrp lxd" command it MUST be the last statement in this script.
#                  That is why we can't combine setup-ciab.sh and setup-containers.sh or even call 
#                  setup-containers.sh from setup-ciab. 

sudo adduser $USER lxd

newgrp lxd








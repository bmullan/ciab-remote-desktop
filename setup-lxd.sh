#!/bin/bash

if [ $(id -u) = 0 ]; then echo "Please DO NOT run this script as either SUDO or ROOT... run it as your normal UserID !"; exit 1 ; fi

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
#================================================================================================================

# set location where the installation files were placed when they were UNTarred.  If you put them somewhere 
# else then change the following to point to that directory

files=/opt/ciab/

#-------------------------------------------------------------------------------------------------------------
# Assumptions:
# 1) you are running this script on the same HOST where we previously installed ciab-desktop 
#    since when we did that all of the ciab-desktop bundled bash scripts etc were all copied onto that machine
#    or vm etc.
# 2) you are in a terminal in the directory on the Host that contains all of the ciab-desktop scripts etc when
#    this setup-lxd.sh script is run
#-------------------------------------------------------------------------------------------------------------

# Now we need to make sure LXD/LXC is installed

# notify user/installer of what we are doing
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

apt purge lxd lxd-client -y

#=========================
# install LXD SNAP package

snap install lxd
# before we start creating containers we need to complete 2 more steps in the LXD setup/configuration

echo "********************************************************************************************************"
echo
echo "Next we need to make sure to initialize LXD which uses the command 'sudo lxd init'."
echo
echo "This command will begin a series of prompts for you to answer questions about the setup of the LXD"
echo "bridge used to communicate from the Host server to the LXD containers.   This bridge by default will"
echo "be called LXDBR0 unless you change that in one of the prompted questions.   Keep the default !"
echo
echo "You will also be asked for the IP address, DHCP etc of the LXD bridge/containers.   Usually the"
echo "defaults work fine."
echo
echo "When prompted for whether you want to configure IPv6... I recommend answering NO for now !"
echo
echo
echo
read -p "Press any key to continue..."
echo
echo 

lxd init
newgrp lxd

exit 0





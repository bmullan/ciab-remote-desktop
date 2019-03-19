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
#
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

#=========================================================================================================
# The next step installs the Desktop environment (our default is Ubuntu-Mate) in the CN1 container.  The  
# mk-cn1-environment.sh script also does a bit more than that though so this will take a while (5-10 min).
#
# Note: 
# The following will execute the mk-cn1-environment.sh script inside CN1 and it will pass
# the installing User/Admin's name via the $USER to the mk-cn1-environment.sh script so 
# it can use that UserID to create the initial user account and Admin/Sudo user for that
# CN1 container

clear

lxc exec cn1 -- /bin/bash -c "/home/$USER/mk-cn1-environment.sh $USER" 

# Now because of an apport bug that causes recurring error msgs to pop up on each login let's
# disable apport on host and cn1

# on host
sudo sed -i 's/enabled=1/enabled=0/' /etc/default/apport

# and in the container disable apport so it doesn't bug users with bogus apport msgs

lxc exec cn1 -- /bin/bash -c "sed -i 's/enabled=1/enabled=0/' /etc/default/apport"

#===========================================================================================================
# There was a problem introduced with Ubuntu 18.04 that sometimes affects loging out of a remote desktop
# session.   This problem was caused by the insertion of following lines of 2 lines into /etc/pam.d/lightdm.
#
# The two line entries were:
#   session optional pam_kwallet.so auto_start
#   session optional pam_kwallet5.so auto_start
#
# We are going to comment those 2 out so the CN1 container and any container cloned 
# from CN1 don't have those 2 entries

# note:  below the long series of spaces btwn "optional" and "pam_kwallet" are required so don't shorten them
#        or the match and substitution won't be made

lxc exec cn1 -- /bin/bash -c "sed -i 's/session optional        pam_kwallet.so auto_start/#session optional        pam_kwallet.so auto_start/' /etc/pam.d/lightdm"
lxc exec cn1 -- /bin/bash -c "sed -i 's/session optional        pam_kwallet5.so auto_start/#session optional        pam_kwallet5.so auto_start/' /etc/pam.d/lightdm"


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
clear

echo
echo
echo
echo "Copying container cn1 to ciab-guac..."
echo
echo "NOTE:  this may take 1-2 minutes so be patient!"
echo
read -p "Press any key to continue..."
echo

lxc stop cn1
lxc copy cn1 ciab-guac

clear
echo
echo "Restarting containers ciab-guac and cn1..."
echo
read -p "Press any key to continue..."
echo

lxc start cn1

# then start it up again

lxc start ciab-guac

sleep 6

#===========================================================
# install ssh-askpass and sshpass in ciab-guac for use later 
# when installing snap nextcloud if required

lxc exec ciab-guac -- /bin/bash -c "apt install ssh-askpass sshpass -y"

#==================================================================================
# install snap lxd in ciab-guac so we can later install CIAB Web Apps as containers

lxc exec ciab-guac -- /bin/bash -c "snap install lxd"


#======================================================================================================
# Next we are going setup the CIAB Host as a "remote" for LXD so lxc commands can be executed
# on the LXD running on the Host in order to: 
# create new containers
# execute commands in those new containers
# delete containers 
# etc
#

clear
echo
while true
  do
   clear
   echo
   echo "==============================================================="
   echo
   read -s -p "Enter a password for Host LXD Remote access: " remote_lxd_pwd
   echo
        read -s -p "Confirm Host LXD Remote Access Password: " remote_pwd2
        echo
        [ "$remote_lxd_pwd" = "$remote_pwd2" ] && break
        echo "Passwords don't match... try again!"
        echo
 done
echo

#==================================================
# now set the Host LXD up to be a "remote" lxd
# NOTE: later from inside the ciab-guac container
# we will execute LXD commands on the Host
# But to do that you will need to remember this
# "remote_lxd_pwd" password 1 time in order to
# set things up
#==================================================

lxc config set core.https_address "[::]" 
lxc config set core.trust_password $remote_lxd_pwd

#=========================
# get IP address of lxdbr0

lxdbr0=$(ip -f inet a show lxdbr0|grep -oP "(?<=inet ).+(?=\/)")

#===========================================================================
# set ciab-guac container to use the Host LXD as a Remote
#
# after completing this, lxc commands can be executed from
# inside ciab-guac against the Host's LXD daemon
#
# NOTE:  the following ONLY sets-up the root/sudo user to be 
#        able to execute lxc commands against the Host's LXD
#        daemon !
#           When logged into ciab-guac and opening a terminal
#        to execute an lxc command you will need to use sudo
#        and include "ciab-host:" as part of the command.
#
#        Examples:    
#                   $ sudo lxc list ciab-host:
#                   $ sudo lxc launch ubuntu:b ciab-host:new_cn_name
#                   $ sudo lxc stop ciab-host:cn_name
#                   $ sudo lxc delete ciab-host:cn_name

clear
echo
echo "The next command will set ciab-guac to use the Host LXD as a Remote."
echo 
echo "When prompted answer 'y' then when prompted for a Password enter"
echo "the Host LXD Remote Access Password you set just previously..."
echo
echo 
lxc exec ciab-guac -- /bin/bash -c  "lxc remote add ciab-host $lxdbr0"

clear

# finally create the Symbolic LINK for freerdp to guacamole freerdp sound driver so sound works

#lxc exec ciab-guac -- /bin/bash -c "ln -s /usr/local/lib/freerdp/guac*.so /usr/lib/x86_64-linux-gnu/freerdp/"

# lets list the LXC containers just to check 

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
echo "Next is the installation of Guacamole, Tomcat8, MySQL"
echo
read -p "Press any key to continue..."

clear

cd $files

#===================================================================================================
# create a /opt/ciab directory in ciab-guac and give ownership to whoever this installer's UserID is
# as we used this UserID to create initial adm/sudo userID in the containers

lxc exec ciab-guac -- /bin/bash -c "mkdir /opt/ciab"
lxc exec ciab-guac -- /bin/bash -c "chown $USER:$USER /opt/ciab"

#===================================================================================================
# Create a directory for the CIAB Apps installer.   The ciab-apps.tar.xz file is included in the
# download of the ciab github files.   So we create a directory /opt/ciab-apps/ to hold the files,

# then untar the ciab-apps files into that directory.
#
# Finally, we create a symbolic link to the executable script to allow installation of ciab apps
# in the CIAB installer's home Desktop directory so it appears on his/her desktop.

lxc exec ciab-guac -- /bin/bash -c "mkdir /opt/ciab-apps"
lxc exec ciab-guac -- /bin/bash -c "chown $USER:$USER /opt/ciab-apps"

#==========================================================================================
# create all the normal subdirectories of /home/$USER (ie ~/Desktop, ~/Downloads etc) prior
# to $USER (the CIAB Installer UserID) ever logging into ciab-guac

lxc exec ciab-guac -- /bin/bash -c "su $USER -c xdg-user-dirs-update" 

lxc exec ciab-guac -- /bin/bash -c "apt install unzip"

# then push the zip/tar.xz file containing all the ciab-apps scripts into ciab-guac into
# /opt/ciab
# 
# then untar/unzip those files but place them into /opt/ciab-apps directory we created above

lxc file push /opt/ciab/ciab-apps-install.* ciab-guac/opt/ciab/
lxc exec ciab-guac -- /bin/bash -c "tar -xvf /opt/ciab/ciab-apps-install.tar* -C /opt/ciab-apps/"

# copy the CIAB Web App Installer .desktop file to the Admin's ciab-guac "Desktop"

lxc file push /opt/ciab/'CIAB Web Applications Installer.desktop' ciab-guac/home/$USER/Desktop/
lxc file push /opt/ciab/ciab-logo.svg ciab-guac/opt/ciab-apps/

lxc exec ciab-guac -- /bin/bash -c "chown $USER:$USER /opt/ciab-apps/*.svg"
lxc exec ciab-guac -- /bin/bash -c "chown $USER:$USER /home/$USER/Desktop/*.desktop"

lxc exec ciab-guac -- /bin/bash -c "chmod 755 /opt/ciab-apps/*.svg"
lxc exec ciab-guac -- /bin/bash -c "chmod 755 /home/$USER/Desktop/*.desktop"

# push the setup-guacamole and setup-nginx scripts into the ciab-guac container'a /opt/ciab

lxc file push /opt/ciab/setup-guacamole.sh ciab-guac/opt/ciab/
lxc file push /opt/ciab/setup-nginx.sh ciab-guac/opt/ciab/

# now execute the setup-guacamole and setup-nginx scripts.  
# since they both need to be executed as sudo/root
# this works fine using "lxc exec"

# first execute setup-guacamole.sh
lxc exec ciab-guac -- /bin/bash -c "/opt/ciab/setup-guacamole.sh"

# then when that is done execute setup-nginx.sh
lxc exec ciab-guac -- /bin/bash -c "/opt/ciab/setup-nginx.sh"

cd $files

clear
echo
echo
echo "One last command will be to use the newish LXD Proxy Device feature to proxy/redirect incoming"
echo "HTTPS connections to the Host/Server .. to the ciab-guac container for handling by guacamole!"
echo
echo "After this executes, any remote user who points their browser to the Server/Host of the LXD"
echo "containers will be redirected to connect to Port 443 on the ciab-guac container where we have"
echo "installed Guacamole, Tomcat, MySQL, NGINXX etc."
echo
echo "The benefit of this are several:"
echo
echo "1 - now ALL of ciab-desktop is installed only in LXD containers."
echo
echo "2 - since the ciab-guac container is on the same private 10.x.x.x subnet as the cn1 Ubuntu-MATE"
echo "    desktop container and any additional containers the installer 'clones' from that original"
echo "    cn1 container... this facilitates using large/powerful Servers in a Cloud or DataCenter"
echo "    to host dozens or possibly hundreds of cnX Ubuntu-Mate Desktop containers that can all"
echo "    be managed in regards to access by the Guacamole Administrator."
echo
echo
echo
read -p "Press any key to finish..."

# proxy port 443 on host to ciab-guac so a web browser trying to connect via port 443 (ie https/tls)
# can connect to the guacamole web server running in ciab-guac container

lxc config device add ciab-guac proxyport443 proxy listen=tcp:0.0.0.0:443 connect=tcp:localhost:443

# and for possible use by letsencrypt to supply a valid HTTPS/TLS certificate letsencrypt needs 
# port 80 open in ciab-guac container so we PROXY DEVICE port 80 on host to ciab-guac

lxc config device add ciab-guac proxyport80 proxy listen=tcp:0.0.0.0:80 connect=tcp:localhost:80

#=================================================================================================
# push our CIAB Guacamole Branding files to the appropriate directories in the ciab-guac container
#=================================================================================================

cd $files

lxc file push ./en.json      ciab-guac/var/lib/tomcat8/webapps/guacamole/translations/
lxc exec ciab-guac -- /bin/bash -c "chown tomcat8:tomcat8 /var/lib/tomcat8/webapps/guacamole/translations/en.json"
#
lxc file push ./ciab-logo.png  ciab-guac/var/lib/tomcat8/webapps/guacamole/images/
lxc exec ciab-guac -- /bin/bash -c "chown tomcat8:tomcat8 /var/lib/tomcat8/webapps/guacamole/images/ciab-logo.png"
#
lxc file push ./branding.jar ciab-guac/etc/guacamole/extensions/
lxc exec ciab-guac -- /bin/bash -c "chown root:root /etc/guacamole/extensions/branding.jar"
#
# restart the ciab-guac container so our CIAB Branding becomes active for logins
lxc restart ciab-guac


clear

echo
echo
echo "==========================={ CIAB Remote Desktop Installation complete! }============================="
echo
echo
echo
echo "Point a Browser to your Host/Server and you should now be able to login to Guacamole and configure:"
echo
echo "1 - Connections to the various LXD containers (ie cn1 & any clones) that you have created"
echo
echo "2 - 'Users' and the 'Connections' they are allowed to connect to."
echo
echo
echo "Once you have completed that you are ready to use CIAB Remote Desktop..."
echo
echo
echo " IMPORTANT Final Note:"
echo 
echo "   If you reboot your CIAB Host system for any reason (shutdown, restart etc) it can take 3-5 minutes for"
echo "   the CIAB Remote Desktop system to fully boot."
echo
echo "   Why?"  
echo
echo "   Because the “Host” itself has to boot, then the ciab-guac container with its Ubuntu-Mate desktop which"
echo "   includes - Guacamole, Tomcat, NGINX, MySQL, has to fully boot and finally the CN1 CIAB Remote Desktop container"
echo "   with its own Ubuntu-Mate Desktop has to complete booting."
echo
echo "   So after every Host system restart be patient and every 30 seconds or so hit refresh on your browser until you" 
echo "   see the CIAB Remote Desktop login screen!"
echo
echo

exit 0




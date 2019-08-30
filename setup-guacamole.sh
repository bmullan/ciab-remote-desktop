#!/bin/bash

clear

# NOTE:  Execute this Script as SUDO or ROOT .. NOT as a normal UserID

# Source:
# http://chari.titanium.ee/script-to-install-guacamole/
# 
# Guacamole installation
# Supports Ubuntu 18.04 
# 32 and 64 bit
# Script to be run as sudo/root
# ver 1.5
# To be run on a FRESH OS install
# Do not install anything other than base OS
# Bharath Chari 2016
# http://chari.titanium.ee
# Updated 03-Feb-2016
 
#=================================================================================
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
#
# All Guacamole source code is Copyright under Apache License, Version 2.0.
#
#=================================================================================


# Check if user is root or sudo and if not exit and tell user to run as sudo/root
if ! [ $(id -u) = 0 ]; then echo "Please run this script as sudo or root"; exit 1 ; fi

#=========================================================
# Version number of Guacamole to install - now version 1.0

GUAC_VER="1.0.0"

# Colors to use for output
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

LOG="/tmp/guacamole_${GUAC_VER}_build.log"
DB="guacamole_db"

# Install apt so we can use it instead of apt-get
apt-get install apt -y

apt update
apt upgrade -y

apt -y install ntp build-essential libcairo2-dev libpng-dev libossp-uuid-dev libjpeg-turbo8-dev uuid-dev 
apt -y install libfreerdp-dev libpango1.0-dev libssh2-1-dev libtelnet-dev libvncserver-dev libpulse-dev libssl-dev libvorbis-dev 
apt -y install apt default-jdk debconf-utils fail2ban freerdp-x11 ghostscript 
apt -y install libavcodec-dev libavutil-dev libswscale-dev libwebp-dev tomcat8 ghostscript jq wget curl
apt -y install libx11-dev libxfixes-dev libssl-dev libpam0g-dev libtool libjpeg-dev 
apt -y install flex bison gettext autoconf libxml-parser-perl libfuse-dev xsltproc libxrandr-dev python-libxml2 
apt -y install nasm xserver-xorg-dev fuse git 

# Get script arguments for non-interactive mode
while [ "$1" != "" ]; do
    case $1 in
        -m | --mysqlpwd )
            shift
            mysqlpwd="$1"
            ;;
        -g | --guacpwd )
            shift
            guacpwd="$1"
            ;;
    esac
    shift
done

# Get MySQL root password and Guacamole User password
if [ -n "$mysqlpwd" ] && [ -n "$guacpwd" ]; then
        mysql_pwd=$mysqlpwd
        guac_db_pwd=$guacpwd
else
    echo
    while true
    do
        clear
        echo
        echo "======================================================="
        echo
        read -s -p "Enter a MySQL ROOT Password: " mysql_pwd
        echo
        read -s -p "Confirm MySQL ROOT Password: " pwd_confirmation
        echo
        [ "$mysql_pwd" = "$pwd_confirmation" ] && break
        echo "Passwords don't match... try again!"
        echo
    done
    echo
    while true
    do
        clear
        echo
        echo "======================================================="
        echo
        read -s -p "Enter a Guacamole User Database Password: " guac_db_pwd
        echo
        read -s -p "Confirm Guacamole User Database Password: " pwd_confirmation
        echo
        [ "$guac_db_pwd" = "$pwd_confirmation" ] && break
        echo "Passwords don't match... try again."
        echo
     done
    echo
fi
clear

debconf-set-selections <<< "mysql-server mysql-server/root_password password $mysql_pwd"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $mysql_pwd"

# Ubuntu 18.04 no longer has libpng-12 which now is replaced by libpng-deg

source /etc/os-release

JPEGTURBO="libjpeg-turbo8-dev"
LIBPNG="libpng-dev"

# Tomcat8 is the default in Ubuntu 18.04 repository as of 9/7/2018

TOMCAT_VER="tomcat8"

# Install features

echo -e "${BLUE}Installing dependencies${NC}"

apt -y install build-essential libcairo2-dev ${JPEGTURBO} ${LIBPNG} libossp-uuid-dev libavcodec-dev libavutil-dev \
libswscale-dev libfreerdp-dev libpango1.0-dev libssh2-1-dev libtelnet-dev libvncserver-dev libpulse-dev libssl-dev \
libvorbis-dev libwebp-dev mysql-server mysql-client mysql-common mysql-utilities libmysql-java ${TOMCAT_VER} freerdp-x11 ghostscript wget dpkg-dev

  if [ $? -ne 0 ]; then
        echo -e "${RED}Failed${NC}"
        exit 1
        else
        echo -e "${GREEN}OK${NC}"
    fi

# If apt fails to run completely the rest of this isn't going to work...
if [ $? -ne 0 ]; then
    echo $-e {FAILED} "apt failed to install all required dependencies"
    exit
fi

# Set SERVER to be the preferred download server from the Apache CDN
SERVER="http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/${GUAC_VER}"
 echo -e "${BLUE}Downloaded Files...${NC}"

wget -q --show-progress -O guacamole-server-${GUAC_VER}.tar.gz ${SERVER}/source/guacamole-server-${GUAC_VER}.tar.gz
tar -xvf guacamole-server*


# Download Guacamole Client
wget -q --show-progress -O guacamole-${GUAC_VER}.war ${SERVER}/binary/guacamole-${GUAC_VER}.war
if [ $? -ne 0 ]; then
    echo "Failed to download guacamole-${GUAC_VER}.war"
    echo "${SERVER}/binary/guacamole-${GUAC_VER}.war"
    exit
    echo -e "${GREEN}Downloaded guacamole-${GUAC_VER}.war${COLOREND}"
fi

# Download Guacamole authentication extensions
wget -q --show-progress -O guacamole-auth-jdbc-${GUAC_VER}.tar.gz ${SERVER}/binary/guacamole-auth-jdbc-${GUAC_VER}.tar.gz
if [ $? -ne 0 ]; then
    echo "Failed to download guacamole-auth-jdbc-${GUAC_VER}.tar.gz"
    echo "${SERVER}/binary/guacamole-auth-jdbc-${GUAC_VER}.tar.gz"
    exit
fi

echo -e "${GREEN}Downloading complete.${NC}"

# Extract Guacamole files
# tar -xzf guacamole-server-${GUACVE##RSION}.tar.gz
tar -xzf guacamole-auth-jdbc-${GUAC_VER}.tar.gz

# Make the /etc directories where we need to store guacamole's extensions
mkdir -p /etc/guacamole/lib
mkdir -p /etc/guacamole/extensions

# save current directory
pushd .

# Install guacd
cd guacamole-server-${GUAC_VER}

# Hack for gcc7

if [[ $(gcc --version | head -n1 | grep -oP '\)\K.*' | awk '{print $1}' | grep "^7" | wc -l) -gt 0 ]]
then
    echo -e "${BLUE}Building Guacamole with GCC6...${NC}"
    apt-get -qq -y install gcc-6
    if [ $? -ne 0 ]; then
        echo -e "${RED}apt-get failed to install gcc-6${NC}"
        exit 1
        else
        echo -e "${GREEN}GCC6 Installed${NC}"
    fi
    CC="gcc-6"

else
    echo -e "${BLUE}Building Guacamole with GCC7...${NC}"
    CC="gcc-7"
fi
     echo -e "${BLUE}Configuring...${NC}"
     ./configure --with-init-dir=/etc/init.d  &>> ${LOG}
    if [ $? -ne 0 ]; then
        echo -e "${RED} Failed${NC}"
        exit 1
        else
        echo -e "${GREEN} OK${NC}"
    fi
     echo -e "${BLUE}Running Make...${NC}"
    make &>> ${LOG}
    if [ $? -ne 0 ]; then
        echo -e "${RED} Failed${NC}"
        exit 1
        else
        echo -e "${GREEN} OK${NC}"
    fi
     echo -e "${BLUE}Running Make Install...${NC}"
     make install &>> ${LOG}
     if [ $? -ne 0 ]; then
        echo -e "${RED} Failed${NC}"
        exit 1
        else
        echo -e "${GREEN}OK${NC}"
    fi
    
ldconfig

# enable the guacd daemon
systemctl enable guacd

# restore the saved directory from the earlier pushd
popd

# Get build-folder
TMP_BUILD_DIR=$(dpkg-architecture -qDEB_BUILD_GNU_TYPE)

#==================================================
# Move files to correct locations on target server.

mv guacamole-${GUAC_VER}.war /etc/guacamole/guacamole.war
ln -s /etc/guacamole/guacamole.war /var/lib/${TOMCAT_VER}/webapps/
#=============================================================================
# The following add links from the Guacamole freerdp .so drivers to
# where they need to be so they can be loaded on boot.   This will allow
# xrdp/freerdp and guacamole to work together to capture sound/audio and
# return it to the end-user via their browser
#
# first make sure the freerdp directory exists - just in case for some
# reason it doesn't... note this will throw an error msg that the 
# directory already exists - if it does already exist but we want to be
# sure

# mkdir /usr/lib/x86_64-linux-gnu/freerdp/

ln -s /usr/local/lib/freerdp/guac*.so /usr/lib/x86_64-linux-gnu/freerdp/
ln -s /usr/share/java/mysql-connector-java.jar /etc/guacamole/lib/
cp guacamole-auth-jdbc-${GUAC_VER}/mysql/guacamole-auth-jdbc-mysql-${GUAC_VER}.jar /etc/guacamole/extensions/

#====================================================================
# Add configuration statements for Mysql to the guacamole.properties

echo "mysql-hostname: localhost" >> /etc/guacamole/guacamole.properties
echo "mysql-port: 3306" >> /etc/guacamole/guacamole.properties
echo "mysql-database: ${DB}" >> /etc/guacamole/guacamole.properties
echo "mysql-username: guacamole_user" >> /etc/guacamole/guacamole.properties
echo "mysql-password: $guac_db_pwd" >> /etc/guacamole/guacamole.properties

# restart Tomcat
echo -e "Restarting Tomcat..."
service ${TOMCAT_VER} restart
if [ $? -ne 0 ]; then
        echo -e "${RED}Failed${NC}"
        exit 1
        else
        echo -e "${GREEN}OK${NC}"
    fi

#===============================================================
# Create guacamole_db and grant guacamole_user permissions to it

# SQL code
MYSQL_CODE="
create database ${DB};
create user 'guacamole_user'@'localhost' identified by \"$guac_db_pwd\";
GRANT SELECT,INSERT,UPDATE,DELETE ON guacamole_db.* TO 'guacamole_user'@'localhost';
flush privileges;"

# Execute SQL code
echo $MYSQL_CODE | mysql -u root -p$mysql_pwd

# Add Guacamole schema to newly created database
echo -e "Adding db tables..."

cat guacamole-auth-jdbc-${GUAC_VER}/mysql/schema/*.sql | mysql -u root -p$mysql_pwd ${DB}
if [ $? -ne 0 ]; then
        echo -e "${RED}Failed${NC}"
        exit 1
        else
        echo -e "${GREEN}OK${NC}"
    fi


# Ensure guacd is started
service guacd start

# Cleanup
echo -e "Cleanup install files..."

rm -rf guacamole-*
if [ $? -ne 0 ]; then
        echo -e "${RED}Failed${NC}"
        exit 1
        else
        echo -e "${GREEN}OK${NC}"
    fi

clear

echo
echo
echo -e "Installation Complete\nhttps://IP_of_Server/guacamole/\n Default login guacadmin:guacadmin\nBe sure to change the password."
echo
echo " Guacamole, MySQL and Tomcat Installation is Done! "
echo
echo
read -p "Press any key to install NGINX..."
clear
echo
echo

exit 0;


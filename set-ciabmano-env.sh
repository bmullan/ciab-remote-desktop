#!/bin/bash

# Purpose:
# this script sets a global environment variable ($ciabmano) in the ciab-admin container
# for use during operations by another script ciabmano.sh.
# ciabmano.sh is executed by the Admins desktop Icon to run the CIAB orchestrator

# NOTE: the following gets executed in the ciab-guac container but
#       uses the lxc of the Host to get the IP address
#
# get IP address of the ciab-mano LXD container where lxdmosaic runs

ciabmano=$(lxc list -c4 --format csv ciab_host:ciab-mano | cut -d' ' -f1)

# substitute the IP address for the placeholder label ciabmano in the /usr/bin/ciabmano.sh script

sed -i "s|ciabmano|$ciabmano|g" /usr/bin/ciabmano.sh


ciabmano="ciabmano="$ciabmano

#=======================================================================
# set lxdbr0 environment variable for any user who has access
# to the ciab-guac container by setting it in the /etc/environment
# file of the ciab-guac container
# we do this since only CIAB Admin's are supposed to have access to it.

echo $ciabmano >> /etc/environment







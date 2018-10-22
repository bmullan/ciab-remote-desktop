#!/bin/bash

#===============================================================================
# setup-proxy.sh
#
# Purpose:  This script needs to be edited by the whoever is the installer.
#           
#
# IMPORTANT:
# 1 - Assumption is that container was already created before executing this
# 2 - Change X.X.X.X to the Host IP address
# 3 - Change Y.Y.Y.Y to the IP address of the container
# 4 - Change the container_name to match your container name
# 5 - Change the Port number from 22 to whatever Port you intend to proxy
# 6 - Change ProxyHost22container22 "name" to reflect the Port you are proxying.
#     NOTE: this is only in case you want multiple different ports proxied
#           from the Host to the Container.
# 7 - the NAT statement does NOT work with apt installed LXD unless it is
#     version 3.5 or greater.   It does work with SNAP LXD as in Ubuntu 18.02
#     to version 3.5 or 3.6 now.
#
# Then:
#      execute this script.
#===============================================================================

HostIP="X.X.X.X"
container_IP="Y.Y.Y.Y"

Host_IpAndPort=tcp:"$HostIP":443

container_name=ciab-guac

container_interface=eth0

container_IpAndPort=tcp:"$container_IP":443

container_proxyDeviceName=ProxyHost443container443

container_Ip="$(echo ${container_IpAndPort} | cut -d: -f2)"

#---------------------------------------------------------------------------
# stop the container container so we can setup a proxy for Port 22 (re ssh)

lxc stop  $container_name

lxc config device override "${container_name}" "${container_interface}" ipv4.address="${container_IP}"

lxc config device remove   "${container_name}" "${container_proxyDeviceName}"

lxc config device add "${container_name}" "${container_proxyDeviceName}" \
  proxy                             \
  listen="${Host_IpAndPort}"        \
  connect="${container_IpAndPort}"  \
  bind=host                         \
  nat=true

lxc start $container_name

lxc config device show "${container_name}"
sudo netstat -nelpv --tcp | grep ":${Host_IpAndPort/*:}"
sudo lsof -n -i ":${Host_IpAndPort/*:}"




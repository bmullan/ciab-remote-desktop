#!/bin/bash

#============================================================================
# setup-proxy.sh
# Purpose:  This script needs to be edited by the ciab-guacamole installer
#
# IMPORTANT:
#
# Change X.X.X.X to the HOST IP address
# Change Y.Y.Y.Y to the IP address of the CIAB-GUAC container
#
# Then:
#      execute this script.
#============================================================================

HostIP="X.X.X.X"
ciab_guacIP="Y.Y.Y.Y"

HOST_IpAndPort=tcp:"$HostIP":443

CONTAINER_name=ciab-guac

CONTAINER_interface=eth0

CONTAINER_IpAndPort=tcp:"$ciab_guacIP":443

CONTAINER_proxyDeviceName=ProxyHost443Container443

CONTAINER_Ip="$(echo ${CONTAINER_IpAndPort} | cut -d: -f2)"

#---------------------------------------------------------------
# stop the ciab-guac container so we can setup a proxy for HTTPS

lxc stop ciab-guac

lxc config device override "${CONTAINER_name}" "${CONTAINER_interface}" ipv4.address="${CONTAINER_Ip}"

lxc config device remove   "${CONTAINER_name}" "${CONTAINER_proxyDeviceName}"

lxc config device add      "${CONTAINER_name}" "${CONTAINER_proxyDeviceName}" \
  proxy                             \
  listen="${HOST_IpAndPort}"        \
  connect="${CONTAINER_IpAndPort}"  \
  bind=host                         \
  nat=true

lxc start ciab-guac

lxc config device show "${CONTAINER_name}"
sudo netstat -nelpv --tcp | grep ":${HOST_IpAndPort/*:}"
sudo lsof -n -i ":${HOST_IpAndPort/*:}"


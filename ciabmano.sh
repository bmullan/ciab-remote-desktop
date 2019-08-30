#!/bin/bash

# purpose:
# this script will take the ciabmano environment variable
# which was previously set by set-ciabmano-env.sh and
# placed in the global /etc/environment file and run
# chromium-browser using that IP address:3000 to execute
# the lxdmosaic (ciabmano)

chromium-browser https://ciabmano:3000


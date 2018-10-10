#!/bin/bash

#==================================================================
# The following are used to setup use of Google Cloud Print service
# and does so in a manner that doesn't make use of chrome or
# chromium-browser mandatory (ie Firefox should work to).
#
# the 2 main packages to install & enable this are:
# cloudprint and cloudprint-service.
#
# cloudprint & cloudprint-service are in the ubuntu repositories
# and can just be installed using
#
#     $ sudo apt install cloudprint cloudprint-service
#
# The cloudprint project page can be found here:
#
#     https://pypi.org/project/cloudprint/
#
# NOTE: this script will need to be run in the Host and in the
#       LXD container(s).
#
# Prerequisites:
# Any local printer you want to print to via cloudprint has to be
# "registered" with the google cloud print service.  To "register"
# a printer you have to have a google account like a gmail or 
# google docs/drive account.
#
# You can read about it here:
#
#      https://support.google.com/cloudprint/answer/1686197?hl=en
#
# With cloudprint installed on CIAB desktop anytime you print with
# any application the pop-up print confirmation box where you 
# select to print to a file or select a printer to print to etc
# will also have an option to log into your Google account and
# select a "cloud ready" printer that you have previously 
# "registered" with that Google Account.   Each CIAB User can thus
# have their own printer choices to be able to remotely to.
#==================================================================

sudo apt install cloudprint cloudprint-service cups-bsd printer-driver-hpcups hp
lip cups-pdf smbclient xpp \
     printer-driver-gutenprint antiword docx2txt python-lockfile-doc python-setu
ptools python-cryptography \
     python-openssl python-socks python-ntlm colord printer-driver-gutenprint cu
ps-browsed imagemagick \
     liblouisutdml-bin liblouis-bin qpdf python-cryptography python-ipaddress py
thon-openssl -y



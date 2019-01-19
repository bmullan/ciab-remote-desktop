#!/bin/bash
/snap/bin/lxc launch ubuntu:b nextcloud
sleep 6
/snap/bin/lxc exec nextcloud -- /bin/bash -c "apt update"
/snap/bin/lxc exec nextcloud -- /bin/bash -c "apt upgrade -y"
/snap/bin/lxc exec nextcloud -- /bin/bash -c "snap install nextcloud"

echo
echo
echo
echo
echo
echo "=========================================================================="
echo
echo "Log into NextCloud with your CIAB Desktop Web Browser using the IP address"
echo "shown below."
echo
echo "NOTE - the first Login ID and Password becomes the NextCloud Admin !"
echo
echo "Write down the NextCloud IP address then press any key to continue..."
echo
echo "=========================================================================="
echo
echo
/snap/bin/lxc list nextcloud
echo
read

exit 0


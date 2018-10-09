# ciab-remote-desktop
CIAB Remote Desktop v1.0 

Pre-reqs:  
Fresh Ubuntu 18.04 server or VM
The ciab-remote-desktop installation scripts.
sudo privileges
 
With this update the CIAB Remote Desktop components all run in LXD Containers which means Guacamole, MySQL, NGINX, Tomcat8, XRDP, XFreeRDP and the Ubuntu MATE desktop environment.

This means you can very easily add more remote desktop servers either on the same LXD Host/Server or on another LXD Host/Server just by copying the existing CN1 container:

$ lxc copy cn1 cn2 

**Please refer to the README.pdf file for more complete documentation on installation and use.**
 

# ciab-remote-desktop
CIAB Remote Desktop v1.0 

Pre-reqs:  
1 - Fresh Ubuntu 18.04 server (cloud or local) or VM  
2 - The ciab-remote-desktop installation scripts.  
3 - sudo privileges on that server  
 
With this update the CIAB Remote Desktop components ALL run in LXD Containers which means Guacamole, MySQL, NGINX, Tomcat8, XRDP, XFreeRDP and the Ubuntu MATE desktop environment.

This means you can very easily add more remote desktop servers either on the same LXD Host/Server or on another LXD Host/Server just by copying the existing CN1 container which only takes a 1-2 minutes:

$ lxc copy cn1 cn2 

This 1.0 version also introduces a new proxy tool that lets you map Port 443 on your Host Server (cloud or VM) to an LXD container called ciab-guac (where guacamole etc gets installed).   Since ciab-guac resides on the same private/internal 10.x.x.x subnet as the cn1 container and any additional containers you clone from the original cn1.   

Depending on the Host Server's number of CPU core, Memory capacity and storage you could potentially have dozens or hundreds of cnX containers, each with its own Ubuntu-Mate Desktop.   This means that remote users can also be configured to potentially access and use any of those dozens or hundres of cnX Ubuntu-Mate Desktops by the Guacamole admin.

For example, on AWS EC2 the largest Virtual Machine you can spin up today approximates this:

> Instance Type..vCPU..Memory (GiB)...Storage (GB)..Network Speed...Physical Processor  
> d2.8xlarge......36....244GBytes......24 x 2TByte....10 Gigabit....Intel Xeon E5-2676 v3

As you can infer from the above, configuring ciab-desktop on such a server could potentially support hundreds of cnX Ubuntu-Mate Desktop containers, each with perhaps dozens of "users" by the Guacamole/CIAB admin of the Server/Host.

**Please refer to the README.pdf file for more complete documentation on installation and use.**
 

![hand](https://user-images.githubusercontent.com/1682855/48496677-8db69f80-e800-11e8-9fda-44b6fa830c04.png)

# CIAB Remote Desktop

CIAB Remote Desktop current version - v1.0.1 

Pre-reqs:  
1 - Fresh Ubuntu 18.04 server (cloud or local) or VM  
2 - The ciab-remote-desktop installation scripts.  
3 - sudo privileges on that server  

There are 2 YouTube video's regarding CIAB:

[CIAB Remote Desktop Part 1 - Installation](https://www.youtube.com/watch?v=d361lS0FH8Y&t=1070s)

and

[CIAB Remote Desktop Part 2 - Configuration and Use](https://www.youtube.com/watch?v=dotc5I2z9mI)

With this update the CIAB Remote Desktop components **all** run in LXD Containers which means Guacamole, MySQL, NGINX, Tomcat8, XRDP, XFreeRDP and the Ubuntu MATE desktop environment.

Installation time depends on the chosen Server/Host's number/type of CPU, amount of RAM and type of disk (SSD or spinning).  

*NOTE:  As an example, on a Server with 4 core, 8GB ram and an SSD disk drive the installation will take between 30-45 minutes.*

After installation you can very easily add more remote desktop server containers either on the same LXD Host/Server or on another LXD Host/Server just by copying the existing CN1 container which only takes a 1-2 minutes:

> $ lxc copy cn1 cn2 

This 1.0.1 version also utilizes the recently added new Device Proxy capability that maps Port 443 on your Host Server (cloud or VM) to an LXD container called ciab-guac (where guacamole etc gets installed).   This means that after installation any CIAB Desktop user that points their Browser to the Host/Server will be redirected to the ciab-guac LXD container.

Since ciab-guac resides on the same private/internal 10.x.x.x subnet as the cn1 container and any additional containers you clone from the original cn1.   

Depending on the Host Server's number of CPU core, Memory capacity and storage you could potentially have dozens or hundreds of cnX containers, each with its own Ubuntu-Mate Desktop.   This means that remote users can also be configured to potentially access and use any of those dozens or hundreds of cnX Ubuntu-Mate Desktops by the Guacamole admin.

For example, on AWS EC2 one of the larger Virtual Machine Instances you can spin up today approximates this:

> **Instance Type**.....**vCPU**.....**Memory (GB)**.........**Storage**...................**Network Performance**  
> **m5d.12xlarge**.........**96**.........**384GBytes**...........**4 x 900GB SSD**..............**25 Gbps**

As you can infer from the above, configuring ciab-desktop on such a server could potentially support many dozens of cnX Ubuntu-Mate Desktop containers, each with perhaps dozens of "users" by the Guacamole/CIAB admin of the Server/Host.

*To get the source scripts & documentation you have the choice of either:*

**downloading the install-all.tar.xz**  
-or-  
**download the individual script file sources.**  

the install-all is just a tar file of all the same script files and is just intended to save you time.

NOTE:  *In mk-cn1-environment.sh there are commented-out sections that show what you need to do if you'd prefer a Desktop Environment (DE) other than Ubuntu-Mate.   Included are xubuntu (xfce4) and budgie DE.*

**Please refer to the README.pdf file for more complete documentation on installation and use.**
 

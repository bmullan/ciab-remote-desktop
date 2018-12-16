![hand](https://user-images.githubusercontent.com/1682855/48496677-8db69f80-e800-11e8-9fda-44b6fa830c04.png)

# CIAB Remote Desktop

CIAB Remote Desktop current version - v1.0.1 

Pre-reqs:  
1 - Fresh Ubuntu 18.04 server (cloud or local) or VM  
2 - The ciab-remote-desktop installation scripts.  
3 - sudo privileges on that server  

> *Note:  A recent addition to the CIAB Remote Desktop [are the CIAB Web Applications](https://github.com/bmullan/ciab-web-applications).    These are a large group of Web based applications that can be installed in LXD containers on the same Host/Server as the CIAB Remote Desktop itself.  Each selected application is installed in a "nested" LXD container inside the ciab-guac LXD container.   This allows the backup or copy of all installed Web Applications just by copying or backing up the ciab-guac container itself.*

There are 2 YouTube video's regarding CIAB:

[CIAB Remote Desktop Part 1 - Installation](https://www.youtube.com/watch?v=d361lS0FH8Y&t=1070s)

and

[CIAB Remote Desktop Part 2 - Configuration and Use](https://www.youtube.com/watch?v=dotc5I2z9mI)

**Important Note:**  
> In this repository is a file called *CIAB System Architecture Mindmap.pdf*.   If you download that PDF you can click on any 
> bubble that has a small link icon in it to drill down/up in the map for further information.   At the CIAB Applications level 
> each Application bubble has a link icon and if you click on that bubble you will be taken to the Documentation webpage for that > particular Web Application.  

With this update the CIAB Remote Desktop components **all** run in LXD Containers which means Guacamole, MySQL, NGINX, Tomcat8, XRDP, XFreeRDP and the Ubuntu MATE desktop environment.

Installation time depends on the chosen Server/Host's number/type of CPU, amount of RAM and type of disk (SSD or spinning).  

> *NOTE:  As an example, on a Server with 4 core, 8GB ram and an SSD disk drive the installation will take between 30-45 minutes.*

After installation you can very easily add more remote desktop server containers either on the same LXD Host/Server or on another LXD Host/Server just by copying the existing CN1 container which only takes a 1-2 minutes:

> $ lxc copy cn1 cn2 

This 1.0.1 version also utilizes the recently added new Device Proxy capability that maps Port 443 on your Host Server (cloud or VM) to an LXD container called ciab-guac (where guacamole etc gets installed).   This means that after installation any CIAB Desktop user that points their Browser to the Host/Server will be redirected to the ciab-guac LXD container.

Since ciab-guac resides on the same private/internal 10.x.x.x subnet as the cn1 container and any additional containers you clone from the original cn1.   

Depending on the Host Server's number of CPU core, Memory capacity and storage you could potentially have dozens or hundreds of cnX containers, each with its own Ubuntu-Mate Desktop.   This means that remote users can also be configured to potentially access and use any of those dozens of cnX Ubuntu-Mate Desktops by the Guacamole admin.

For example, on AWS EC2 one of the larger Virtual Machine Instances you can spin up today approximates this:

> **Instance Type**.....**vCPU**.....**Memory (GB)**.........**Storage**...................**Network Performance**  
> **m5d.12xlarge**.........**96**.........**384GBytes**...........**4 x 900GB SSD**..............**25 Gbps**

As you can infer from the above, configuring ciab-desktop on such a server could potentially support many dozens of cnX Ubuntu-Mate Desktop containers, each with perhaps dozens of "users" by the Guacamole/CIAB admin of the Server/Host.

_If you download the Installation script source files and the CIAB-README.pdf documenation file using GitHub’s ZIP file format the resulting archive will be called - “**ciab-remote-desktop-master.zip**”_

> NOTE:  *In mk-cn1-environment.sh there are commented-out sections that show what you need to do if you'd prefer a Desktop Environment (DE) other than Ubuntu-Mate.   Included are xubuntu (xfce4) and budgie DE.*

**Please refer to the CIAB-README.pdf file for more complete documentation on installation and use.**
 

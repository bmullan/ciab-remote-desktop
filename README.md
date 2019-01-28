![ciab-logo](https://user-images.githubusercontent.com/1682855/51850975-ea4e3480-22f0-11e9-9128-d945e1e2a9ab.png?classes=float-left)
### is a ***clientless*** remote desktop system.  It's called *"clientless"* because no plugins or client software are required!   
  
Thanks to HTML5, once the CIAB Remote Desktop System is installed on a Server/VM/Cloud instance, all you need to access your desktop(s) is an HTML5 capable web browser!  

# CIAB version 2.1 desktop System - v2.1
### v 2.1 introduces the following improvements and new features:

Both file uploads and downloads now work between a Users local PC and their CIAB Remote Desktop system.

Entry of a Login ID and Password is now only required one time for both CIAB's Guacamole and the CIAB Remote Desktop connections. 

If a CIAB User only has a single Remote Desktop connection configured for them they will be connected to that Desktop immediately after entering their User ID and Password.
     
> **IMPORTANT NOTE**    
>  
> Please review the **CIAB - README.pdf !**  
>  
>*The PDF has been _significantly_ updated/improved* in regards to not only the new features but also the overall CIAB Installation process!  
>
> Some of the new capabilities (such as file download and only requiring Login ID and Password once) will *require* some _minor_ editing of existing CIAB Guacamole **CIAB-GUAC** and **CN1** "connection" configurations for the new capabilities to work correctly!

## CIAB Remote Desktop System v2.0 

**CIAB Remote Desktop System current version - v2.x** 

*Pre-reqs:*  
1 - Fresh Ubuntu 18.04 server (cloud or local) or VM  
2 - The CIAB Remote Desktop system files contained in this GitHub repository which include all of the installation scripts.  
3 - sudo privileges on that server  

**NOTE**:  With CIAB Remote Desktop System v2.x we introduced several major enhancements!

CIAB has been updated with Guacamole v1.0.0 which was released January 2019.   This version of Guacamole now supports many new capabilities such as:

* Support for user groups  
* Multi-factor authentication with Google Authenticator / TOTP  
* Support for RADIUS authentication  
* Support for creating ad-hoc connections  
* Support for renaming RDP drive and printer  
* Cut & Paste for text-only (no pictures) now works as it normally would on a desktop 
* Configurable terminal color schemes  
* Optional recording of input events  
* SSH host key verification  
* Automatic detection of network issues  
* Support for systemd  
* Incorrect status reported for sessions closed by RDP server  
* Automatic connection behavior which means Guacamole will automatically connect upon login for users that have access to only a single connection, skipping the home screen.  

A recent addition to the CIAB Remote Desktop are the CIAB Web Applications!  Previously, this had to be installed separately after the CIAB Remote Desktop system had been installed.   

With CIAB Remote Desktop System v2.0 this has now been integrated so that the CIAB Admin will see an Icon on their Mate Desktop when they log into the CIAB-GUAC LXD container desktop.   

To install one or more of those CIAB Web Apps you just have to click on that Icon and when prompted select "RUN IN A TERMINAL" and after doing so you will be presented with a GUI Menu where you can Check the boxes for one or more Web Applications you'd like to install.

> NOTE:  These applications will be installed as "**nested**" LXD containers inside the CIAB-GUAC container but they will all be attached to the **same** 10.x.x.x private network that the CIAB-GUAC and the CN1 containers are attached to.   The design of this using the "nested" LXD containers and private network has greatly enhanced the security regarding using these Web Applications as only validated users with CIAB Accounts and a login on the CN1 Mate Desktop container will have access to those web applications unless the CIAB Admin allows access from the internet via a separate configuration requirement.

Read more about the CIAB Web Application later in the Section of this README titled "CIAB Web Applications".

These are a large group of Web based applications.  Each selected application is installed in a "**nested**" LXD container inside the ciab-guac LXD container.   This allows the backup or copy of all installed Web Applications just by copying or backing up the ciab-guac container itself!*

There are 2 YouTube video's regarding CIAB:

[CIAB Remote Desktop Part 1 - Installation](https://www.youtube.com/watch?v=d361lS0FH8Y&t=1070s)

and

[CIAB Remote Desktop Part 2 - Configuration and Use](https://www.youtube.com/watch?v=dotc5I2z9mI)

**Important Note:**  
> In this repository is a file called _**CIAB System Architecture Mindmap.pdf**_.   If you download that PDF you can click on any 
> bubble that has a small link icon in it to drill down/up in the map for further information.   At the CIAB Applications level 
> each Application bubble has a link icon and if you click on that bubble you will be taken to the Documentation webpage for that > particular Web Application.  

With this update the CIAB Remote Desktop components **all** run in LXD Containers which means Guacamole, MySQL, NGINX, Tomcat8, XRDP, XFreeRDP and the Ubuntu MATE desktop environment.

Installation time depends on the chosen Server/Host's number/type of CPU, amount of RAM and type of disk (SSD or spinning).  

> *NOTE:  As an example, on a Server with 4 core, 8GB ram and an SSD disk drive the installation will take between 30-45 minutes.*

After installation you can very easily add more remote desktop server containers either on the same LXD Host/Server or on another LXD Host/Server just by copying the existing CN1 container which only takes a 1-2 minutes:

> $ lxc copy cn1 cn2 

This 2.0 version also utilizes the recently added new Device Proxy capability that maps Port 443 on your Host Server (cloud or VM) to an LXD container called ciab-guac (where guacamole etc gets installed).   This means that after installation any CIAB Desktop user that points their Browser to the Host/Server will be redirected to the ciab-guac LXD container.

Since ciab-guac resides on the same private/internal 10.x.x.x subnet as the cn1 container and any additional containers you clone from the original cn1, they can all inter-communicate with one another.   Also, any CIAB Web Applications the Admin installs will also be attached to this same 10.x.x.x network allowing validated CIAB Users logged into the Mate Desktop on CN1 to use their browser to access those applications.

Depending on the Host Server's number of CPU core, Memory capacity and storage you could potentially have dozens or hundreds of cnX containers, each with its own Ubuntu-Mate Desktop.   This means that remote users can also be configured to potentially access and use any of those dozens of cnX Ubuntu-Mate Desktops by the Guacamole admin.

For example, on AWS EC2 one of the larger Virtual Machine Instances you can spin up today approximates this:

> **Instance Type**.....**vCPU**.....**Memory (GB)**.........**Storage**...................**Network Performance**  
> **m5d.12xlarge**.........**96**.........**384GBytes**...........**4 x 900GB SSD**..............**25 Gbps**

As you can infer from the above, configuring ciab-desktop on such a server could potentially support many dozens of cnX Ubuntu-Mate Desktop containers, each with perhaps dozens of "users" by the Guacamole/CIAB admin of the Server/Host.

_If you download the Installation script source files and the CIAB-README.pdf documenation file using GitHub’s ZIP file format the resulting archive will be called - “**ciab-remote-desktop-master.zip**”_

> NOTE:  *In mk-cn1-environment.sh there are commented-out sections that show what you need to do if you'd prefer a Desktop Environment (DE) other than Ubuntu-Mate.   Included are xubuntu (xfce4) and budgie DE.*

**Please refer to the CIAB-README.pdf file for more complete documentation on installation and use.**

---

# CIAB Web Applications

![ciab-logo](https://user-images.githubusercontent.com/1682855/48973170-36d27680-f007-11e8-9241-db2dbaa74205.png)

## Installable Web Applications for use by CIAB Remote Desktop Users.
___

This repository contains scripts and a large group of Web based applications that can be installed in LXD containers
on the same Host/Server as the CIAB Remote Desktop itself.

These applications can only be installed by the CIAB Remote Desktop Administrator.

**Benefits:**

Each application selection by the Administrator will be installed in its own LXD container attached to the
same 10.x.x.x private network as the CIAB Remote Desktop container(s) and thus will **only** be accessible
to validated users of the installed CIAB Remote Desktop system, *not from the Internet*!

Since CIAB Remote Desktop users must be first configured with valid accounts in Guacamole and *can only access
CIAB LXD Desktop Servers they have been given access to by the Administrator* this **significantly reduces the
*Security exposure footprint* from any intrusion from the Internet**.

Remember, nothing is running on the Host/Server on which the CIAB Remote Desktop system has been installed
except LXD.   Everything else is running in *unprivileged* LXD Containers on that Host/Server.

Only the CIAB Administrator that initially installed the CIAB System would have a User Account on the Host/Server and
has total control over any Ports open.   Usually only Ports 22 (ssh) and 443 (Https) are open on the Host/Server.

Direct Internet access **to** these applications & the LXD containers they run in is prohibited by design.   

If access to these Web Applications is desired there is a relatively easy configuration change which would enable such, so that users on the "internet" could access the Web Applications also while still being under the control/adminstration of the CIAB Administrator.   

To enable Internet access to any installed CIAB Web Applications the administrator has to issue two commands for each installed application.   Both commands are related in that they will setup a *"chain" of Port Forwarding*.    First from the internet into the ciab-guac container and then for that port into the LXD container of the target CIAB Web Application.

Example for the Drupal CMS application lets say we want to use Port 8000 from the internet to access it.   From the Host server we would first issue the following:  
> lxc config device add **ciab-guac** proxyport**8000** proxy listen=tcp:0.0.0.0:**8000** connect=tcp:localhost:**8000**  
then *from inside the ciab-guac* container...   
> lxc config device add **drupal** proxyport**8000** proxy listen=tcp:0.0.0.0:**8000** connect=tcp:localhost:**8000**  

NOTE:  the label "proxyport" is arbitrary and is just an identifier.   Port 8000 is also somewhat arbitrary in that you can choose any port that is **not a "well-known port"** an [IANA reserved port (ie 0 - 1023)](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml). 

However, the various applications *do have access out to the Internet* and thus their functionality is not restricted.

But again, only CIAB Remote Desktop users logged into one of the LXD Remote Desktop LXD containers and using that
container's Web Browser can access and log into these web applications.

_**Another big benefit involves Backups**_.  

Because all of the CIAB Web Applications are installed in *nested* LXD containers inside of the **ciab-guac** container, if you backup or copy the **ciab-guac** container you will automatically be backing up/copying all of your installed applications too!  

Also, the same for restores if it is ever required!

*Keep in mind if you have installed a lot of the CIAB Web Applications and users have input a lot of data into them, the backup may take a while to complete and you need to insure that the backup remote LXD server has appropriate free disk space.*

**Reference**:  https://lxd.readthedocs.io/en/latest/backup/  

A good thread on LXD backups that includes comments by Stephane Graber, the lead for the LXD project, [can be found here](
https://discuss.linuxcontainers.org/t/backup-the-container-and-install-it-on-another-server/463/12)



## Important (PLEASE READ)

1. These applications are being provided for installation only.  The installer is designed to install any
   selected Application into an *existing* CIAB Remote Desktop environment!   
2. *NO SUPPORT* for the Applications is provided except through the Application's original Author or Organization's website  
   and any support mechanisms they have (forum, for-fee, mailer alias etc)!_  
3. *ANY & ALL future upgrades to these Applications are the SOLE responsibility of the Installer, the Organization the 
   applications are being installed for, and/or any Contracted Support arranged with the Application Authors/Creators or 3rd 
   Parties. So if you believe you will eventually need or want to upgrade an application & migrate the existing data please 
   research how this needs to be done sooner than later!*     
___

### The current list of Applications available to be installed are of several Categories:

---

#### **Content Management Systems (CMS)**

**Drupal** - Both Drupal and Joomla are widely used world-wide and *BOTH* have *dozens and dozens of add-ons* you can easily install.  

**Joomla** - see above

**WordPress** - One of the most popular blogging & content management platforms worldwide.

---

#### **Enterprise Resource Management (ERP)**

**ERPNext** -  ERPNext supports manufacturing, distribution, retail, trading, services, education, 
           non profits and includes Accounting, Inventory, Manufacturing, CRM, Sales, Purchase, 
           Project Management, and a Human Resource Management System (HRMS).

---

#### **Learning Management Systems (LRM)**

**Moodle** - Moodle is a learning platform designed to provide educators, administrators 
         and learners with a single robust, secure and integrated system to create 
         personalised learning environments.  *Moodle can also be used by Businesses
         to help plan/manage Training for Employees.*  

---

#### **Human Resource Management (HRM)**

**OrangeHRM** - a complete open source HR management system.  

---

#### **Business & eCommerce**

**PrestaShop** - PrestaShop is an efficient and innovative e-commerce solution with all the 
             features you need to create an online store and grow your business.  
             
**Mahara** - Mahara is a fully featured electronic portfolio, weblog, resume builder and social 
         networking system, connecting users and creating online communities. Mahara 
         provides you with the tools to set up a personal learning and development environment.  

**OSClass** - online classified Ads  

**Mautic** - Mautic provides free and open source marketing automation software available to 
         everyone. Free email marketing software, lead management software  

**Odoo** - Odoo is a suite of web based open source business apps. The main Odoo Apps include 
       an Open Source CRM, Website Builder, eCommerce, Warehouse Management, Project Management, 
       Billing & Accounting, Point of Sale, Human Resources  

**iTop** - iTop stands for IT Operations Portal. It is a complete open source, ITIL, web based 
       service management tool including a fully customizable Configuration Mangement Database (CMDB), 
       a Helpdesk system and a Document Management tool.  iTop also offers mass import tools and
       web services to integrate with your IT  

---

#### **Project Management**

**Open Atrium** - BOTH Open Atrium and Open Project are widely used World-Wide and either can provide comprehensive Project Management capabilities.   

**Open Project**  - see above 

---

#### **Social Media Systems**

**Discourse** - Discourse is the next-next-generation community forum platform which allows you to create categories, tag posts, manage notifications, create user profiles, and includes features to let communities govern themselves by voting out trolls and spammers. Discourse is built for mobile from the ground up and support high-res devices.

**MediaWiki** - Mediawiki is the core of Wikipedia.  A wiki enables communities of editors and contributors to write documents collaboratively.

**Ghost** - blogging platform  

---

#### **Miscellaneous**

**NextCloud** - Nextcloud is an open source, self-hosted file share and communication platform. 
            Access & sync your files, contacts, calendars & communicate and collaborate.  

**RStudio** - RStudio is an integrated development environment for *R, a programming language for statistical computing and 
          graphics*. 

**nuBuilder4** - A browser-based tool for developing web-based database Applications accessible from the CIAB Desktop(s). Using MySQL databases it gives users the ability to easily do database operations like... Search, Create, Insert, Read, Update, Delete. It includes low-code tools that... Drag and Drop objects, Create database queries with the SQL Builder, Create customised date and number formats with the Format Builder, Create calculated fields with the Formula Builder, Create Fast Forms, Create Fast Reports, 

**CiviCRM** - CiviCRM is web-based software used by a diverse range of organisations, particularly 
          not-for-profit organizations (nonprofits and civic sector organizations).   

**Lime Survey** - Create & run Online Surveys.  *NOTE: to login as Lime Survey Admin goto http://<ip_addr>/admin*  

**Mantis** - Mantis Defect/Problem Tracker is a free and open source, web-based tracking system.  

---

## How to install CIAB Web Applications  

**Pre-requisite**  
An existing CIAB Remote Desktop System Installation on an Ubuntu 18.04 VM/Physical Server/Cloud instance **Host** is required for installation of the CIAB Web Applications.   

The CIAB Admin (person who installed the CIAB Remote Desktop System) when they use Guacamole to log into the CIAB-GUAC container's MATE desktop will find a new ICON on their Desktop named:

> **CIAB Web Applications Installer**  

To install one or more of the CIAB Web Applications the Admin needs to click on the **CIAB Web Applications Installer** icon.

**Each** web application's installation can take up to 5 minutes.  So be patient as there may be times where there will seem to be no activity for upto 60 seconds or so.

Currently, all applications are installed using Bitnami .RUN files (https:\/\/bitnami.com\/) *except for* iTop, NextCloud and NuBuilder which are not Bitnami applications and thus require their own installation scripts.   

*Additional CIAB applications will be added in the future.*

Each selected application will be installed into its own LXD container _**nested**_ in the **ciab-guac** container.

> **NOTE**: NextCloud is an exception to this.  Due to a bug with AppArmor and "nested" AppArmor profiles we cannot install the SNAP version of NextCloud in a "nested" container as with the other applications.   So NextCloud is installed in an LXD container called "nextcloud" in the Host/Server and is attached to the same private 10.x.x.x network as all the other containers.   If you (ie CIAB Admin) need to delete/copy/start etc the NextCloud container you will have to ssh into the Host and execute the appropirate LXC commands there (re - lxc list nextcloud, lxc stop nextcloud etc)

Each of those Web Application Containers will be attached to the same lxdbr0 bridge via the ETH0 interface of the **ciab-guac** container and thus those Web Application containers will be allocated a 10.x.x.x IP address on the same subnet as **ciab-guac** and the initial **cn1** Ubuntu-Mate desktop container.  

After applications have been installed you can:  

1. get a full list of installed applications & their LXD container IP addresses by opening a terminal when logged into the **ciab-guac** container and executing:

> $ **lxc list**

Next, you should log into the *CIAB Remote Desktop* using your local web browser to access Guacamole which is running in the **cn1** LXD container.

When you are logged into a *CIAB Ubuntu-Mate desktop*, start a web browser on that Desktop and point it to the 10.x.x.x IP address of any of the applications you installed.   

**NOTE**:  Most of the applications are reachable with a URL like "10.x.x.x/app_name".

*Example*:  

Lets say the WordPress application was installed in an LXD container with IP address 10.16.124.50.

You would point the CIAB Remote Desktop browser to *"http:\/\/10.16.124.50\/wordpress"*

**TIP/Hint**:  
As an Admin you could make life easier for the users by modifying the CIAB Remote Desktop container  (re cn1, cn2 etc) **/etc/hosts** file and adding entries for each CIAB Application you installed.

*Example /etc/hosts in CN1 container*:  

> $ **more hosts**  
> 127.0.0.1	localhost  
> 127.0.1.1	cn1  
> **10.16.124.50/wordpress  wordpress**  
> **10.16.124.72/erpnext  erpnext**  
> **10.16.124.164/nextcloud nextcloud**  
>  
> \# The following lines are desirable for IPv6 capable hosts  
> ::1     ip6-localhost ip6-loopback  
> ff02::1 ip6-allnodes  
> ff02::2 ip6-allrouters  

after completing this a CiAB Remote Desktop user can access any of the installed apps by using the URL:

> **http:\/\/wordpress**

which is simpler to remember than the 10.x.x.x IP addresses of each application container.

**NOTE**:  
If you screw-up any of the CIAB Application installations (entered something wrong during installation) you, the CIAB Admin, can simply stop then delete that Application's LXD container and then reinstall it again!   

Just open a terminal and execute:  
> $ lxc stop <container/application name>  
> $ lxc delete <container/application name>  

Example - you entered something wrong with wordpress's installation

> log into the **ciab-guac** container desktop  
> open a terminal then..  
>  \$ lxc stop wordpress  
>  \$ lxc delete wordpress  

Then reinstall wordpress by following the above CIAB Apps installation process agin and after running **ciab-apps-install.sh**  and select *wordpress* to reinstall it (_**Note**_: it may get a different IP address upon reinstallation).

___
Again...  there will be more Web Based Applications added in the future.


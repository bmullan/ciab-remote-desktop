![ciab-logo](https://user-images.githubusercontent.com/1682855/51850975-ea4e3480-22f0-11e9-9128-d945e1e2a9ab.png?classes=float-left)  

**I am happy to introduce CIAB v3 !**  a major upgrade & refactoring of the CIAB Remote Desktop System.


**CIAB** ("*Cloud-In-A-Box*") v3 Remote Desktop System is a server application that integrates and extends the [Apache Guacamole](https://guacamole.apache.org/) clientless remote desktop gateway on a Ubuntu 18.04 LTS host with LXD containers. 

The CIAB Administrator can also easily deploy a number of web applications (see below) using a GUI tool provided on the Admin's Desktop.

Using **only** a web browser that supports HTML5, users can connect to this web interface and access web applications and the Ubuntu Mate desktop as pre-configured and authorized by the CIAB administrator.

The initial installation configures four LXD containers:

- **CIAB-ADMIN**: An LXD container meant for CIAB Adminstrator use.   This provides access to the CIAB Management and Orchestration (MANO) tool based on LXDMosaic and to the CIAB Web Applications Installation too.
- **CIAB-MANO**: An LXD container where [LXDMosaic](https://github.com/turtle0x1/LxdMosaic) is installed.  LXDMosaic provides a GUI Management and Orchestration (MANO) of LXD containers both on the Local LXD Host/Server and on Remote LXD Host/Servers
- **CIAB-GUAC**: An LXD container where Apache Guacamole, Tomcat, NGINX, MySQL and XRDP run. 
- **CN1** : An LXD container where CIAB End-Users connect to their CIAB Ubuntu-Mate Remote Desktop, accessible via RDP using the CIAB Guacamole front-end.

CIAB is a ***clientless*** remote desktop system.  It's called *"clientless"* because no plugins or client software are required!   
    
**PLEASE REVIEW** this GitHub Repository _**[Issues](https://github.com/bmullan/ciab-remote-desktop/issues)**_ Section for **IMPORTANT** CIAB bug fix info and Use TIPS...!

---

**Complete [CIAB Documentation is contained in the CIAB Repository's README.PDF file](https://github.com/bmullan/ciab-remote-desktop/blob/master/CIAB%20-%20README.pdf).**

## What is the CIAB Remote Desktop System?

CIAB Remote Desktop (CIAB – Cloud-In-A-Box) was originally envisioned around 2008 after I had the opportunity from my then employer Cisco Systems to spend nearly 18 months on a Fellowship with a non-profit here in North Carolina that provides the networking connectivity (NCREN) to all of the schools in North Carolina.

At the time, cloud computing was just beginning and Amazon's AWS was practically the only game in town.   Having used AWS myself quite a bit by that time I tried to investigate how “cloud” could be used by K-12 schools as a possible low cost solution to the problems they faced such as:

    • lack of funds often prevent hiring top tech support or buying new equipment
    • local inexperienced technical support which often-times consisted of a librarian, teacher or volunteers 
    • a hodge-podge of mixed old/new computers (desktop, laptops)   

Today the available computers now also include mixes of chromebooks, tablets as well.   Security & viruses on the student machines are still constant problem.

The above circumstances and combination of problems often created a frustrating experience for teachers, students and parents.   So in 2008 I first starting thinking about how to bring together a Cloud based Remote Desktop solution that while not solving every problem, would try to adhere to the 80/20 rule of trying to solve 80% of the problems.

CIAB Remote Desktop only requires a working HTML5 web browser 
on your local PC/Laptop/Chromebook!  

The amount of memory, disk drive space, operating system on the local computers *no longer matters* as the real User “desktops” are remote and the “server” they run on can be scaled in the “cloud” to as large as needed in size or number based on availability.  

The school would only need decent Network connectivity in regards to speed & reliability.

_**Today... CIAB has evolved in design beyond schools for use-cases in business, non-profits and even large wind energy plants.**_

_CIAB today implements its management tools and the end-user Desktops in LXD "unprivileged" containers running on any Ubuntu 18.04 LTS (long term support) Host/Server whether a VM, physical server or Cloud instance._

_**Here are 3 YouTube video's regarding CIAB v3 which will help you understand and configure CIAB**_:

[CIAB Remote Desktop System v3 - Introduction and Demo of Use](https://youtu.be/MUCXn7WoT3c)

[CIAB v3 Remote Desktop  System - Installation](https://youtu.be/VRmSvdSmoqI)

[CIAB v3 Guacamole Configuration and Wrapup](https://youtu.be/neDFdP-UhzI)

After installation you can very easily add more remote desktop server containers either on the same LXD Host/Server or on another LXD Host/Server just by copying the existing CN1 container (or all of CIAB) _which only takes a few minutes to do_.

CIAB v3 utilizes the LXD Device Proxy capability that maps Port 443 on your Host Server (cloud or VM) to an LXD container called **ciab-guac** (where guacamole etc gets installed).   

This means that after installation any CIAB Desktop user that points their Browser to the Host/Server will be redirected to the ciab-guac LXD container first where Guacamole will then process that User for further connections (ie to CN1) according to the Configurations made by the CIAB Admin.  

If the CIAB Admin has configured that User for access to the CN1 Desktop Container or possibly other CNx containers that may have been configured on the CIAB "Host/Server" then the User will be presented with a menu to select which "connection" they want to log into.

Since the **ciab-guac** container resides on the same private/internal 10.x.x.x subnet as the **cn1** container and any additional containers you clone from the original cn1 or to/from any CIAB Admin installed CIAB Web Applications can all inter-communicate with one another.   

Any validated CIAB Users logged into the Mate Desktop on CN1 can use their CN1 Mate Desktop's browser to access installed CIAB Web applications.

Depending on the Host Server's number of CPU core, Memory capacity and storage you could potentially have dozens or hundreds of cnX containers, each with its own Ubuntu-Mate Desktop.   This means that remote users can also be configured to potentially access and use any of those dozens of cnX Ubuntu-Mate Desktops by the Guacamole admin.

For example, on AWS EC2 one of the larger Virtual Machine Instances you can spin up today approximates this:

> **Instance Type**.....**vCPU**.....**Memory (GB)**.........**Storage**...................**Network Performance**  
> **m5d.12xlarge**.........**96**.........**384GBytes**...........**4 x 900GB SSD**..............**25 Gbps**

As you can infer from the above, configuring ciab-desktop on such a server could potentially support many dozens of cnX Ubuntu-Mate Desktop containers, each with perhaps dozens of "users" by the Guacamole/CIAB admin of the Server/Host.

_If you download the Installation script source files and the CIAB-README.pdf documenation file using GitHub’s ZIP file format the resulting archive will be called - “**ciab-remote-desktop-master.zip**”_

> NOTE:  *In **mk-cn1-environment.sh** there are commented-out sections that show what you need to do if you'd prefer a Desktop Environment (DE) other than Ubuntu-Mate.   Included are xubuntu (xfce4) and budgie DE.*

**The latest [CIAB Installation and Configuration Documentation is contained in the CIAB Repository's README.PDF file](https://github.com/bmullan/ciab-remote-desktop/blob/master/CIAB%20-%20README.pdf).**

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

If the CIAB Admin desires to enable Internet access to any installed CIAB Web Applications the administrator has to issue two commands for each installed application.   Both commands are related in that they will setup a *"chain" of Port Forwarding*.    First from the internet into the ciab-guac container and then for that port into the LXD container of the target CIAB Web Application.

Example for the Drupal CMS application lets say we want to use Port 8000 from the internet to access it.   From the Host server we would first issue the following:  
> lxc config device add **ciab-guac** proxyport**8000** proxy listen=tcp:0.0.0.0:**8000** connect=tcp:127.0.0.1:**8000**  
then *from inside the ciab-guac* container...   
> lxc config device add **drupal** proxyport**8000** proxy listen=tcp:0.0.0.0:**8000** connect=tcp:127.0.0.1:**8000**  

NOTE:  the label "proxyport" is arbitrary and is just an identifier.   Port 8000 is also somewhat arbitrary in that you can choose any port that is **not a "well-known port"** an [IANA reserved port (ie 0 - 1023)](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml). 

However, the various applications *do have access **outbound only** to the Internet* and thus their functionality is not restricted.

But again, only CIAB Remote Desktop users logged into one of the LXD Remote Desktop LXD containers and using that
container's Web Browser can access and log into these web applications.

_**Another big benefit involves Backups**_.  

*Keep in mind if you have installed a lot of the CIAB Web Applications and users have input a lot of data into them, the backup may take a while to complete and you need to insure that the backup remote LXD server has appropriate free disk space.*

**Reference**:  https://lxd.readthedocs.io/en/latest/backup/  

A good thread on LXD backups that includes comments by Stephane Graber, the lead for the LXD project, [can be found here](
https://discuss.linuxcontainers.org/t/backup-the-container-and-install-it-on-another-server/463/12)

New to CIAB v3 is the addition of the CIAB MANO (Management and Orchestration) Tool based on LXDMosaic.   Using CIAB MANO the CIAB Admin can easily create/restore **snapshots** of any of the installed LXD containers whether they be part of CIAB itself -or- any of the CIAB Web Application containers.

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

After completion of the installation of any CIAB Web Applications there may be important information displayed regarding login/access information (specific default admin login IDs or passwords, specific Port numbers that must be used/open etc).

So the CIAB Admin should, upon completion of the installation, record any important information like this and if necessary perform any additional configuration requirements such as opening a Port in that Application's LXD container Firewall etc.

*Additional CIAB applications will be added in the future.*

Each selected application will be installed into its own LXD container.

Each of those Web Application Containers will be attached to the same lxdbr0 bridge via their container's ETH0 interface and thus those Web Application containers will be allocated a 10.x.x.x IP address on the same subnet as **ciab-guac** and the initial **cn1** Ubuntu-Mate desktop container.  

After applications have been installed you can:  

1. get a full list of installed applications & their LXD container IP addresses by opening a terminal when logged into the **ciab-guac** container and executing:

> $ **lxc list ciab-host:**

Next, you should log into the *CIAB Remote Desktop* using your local web browser to access Guacamole which is running in the **cn1** LXD container.

When you are logged into a *CIAB Ubuntu-Mate desktop*, start a web browser on that Desktop and point it to the 10.x.x.x IP address of any of the applications you installed.   

**NOTE**:  Most of the applications are reachable with a URL like "10.x.x.x/app_name".

*Example*:  

Lets say the WordPress application was installed in an LXD container with IP address 10.16.124.50.

You want to login as admin and add/edit content on the Wordpress blog.  
You would point the CIAB Remote Desktop browser to *"http:\/\/10.16.124.50\/wp-admin"*

If a CIAB User just wanted to read the WordPress Blog they would point the CIAB Remote Desktop browser  
to *"http:\/\/10.16.124.50\/"*  

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
If you screw-up any of the CIAB Application installations (entered something wrong during installation) you, the CIAB Admin, can use the CIAB MANO tool to stop/delete that Application's LXD container.   Then the CIAB Admin can just reinstall that CIAB Web Application again!   

___
Again...  there will be more Web Based Applications added in the future.


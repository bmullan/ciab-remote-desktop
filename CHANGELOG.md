##Release Notes

\==================
v2.2 Release Notes
\==================

CIAB has had a redesign of how the CIAB Web App Containers are created.

Previously, in v2.1 they were created as "nested" LXD containers inside the ciab-guac container.

Due to a couple bugs in Apparmor that are related to "nested" Apparmor profiles which may take quite 
a while to be resolved I have redesigned how the CIAB Web Apps are deployed. 

They are now created as normal LXD (ie non-nested) containers at the same container level as the 
ciab-guac and CN1 containers.

Note: the Web App containers and their applications are still isolated to the private 10.x.x.x network 
and still accessible by Remote Desktop users of the CN1 environment. 

Those Web App containers also still retain access to the Internet but are isolated from direct access 
"from" the Internet. CIAB version 2.2 introduces the following improvements.

Any CIAB Web-Apps installed by the CIAB Admin from the Menu available on their CIAB-GUAC container 
Mate Desktop now get installed in LXD Containers as “peer containers” on the 10.x.x.x private network 
that CIAB-GUAC and CN1 containers are on.

This is a change from CIAB’s previous use of “nested” containers for the CIAB Web-Apps and was driven 
by a bug in upstream Apparmor concerning “nested” Apparmor profiles. 

That bug may be a while before it is fixed so a decision was made to make this change.

Now as Admin, from the Host/Server, you can find/see all installed applications and the CIAB-GUAC and 
CN1 containers and their IP addresses by executing:

    $ lxc list

Also, in CIAB v2.2, TOTP (Timed One Time Password) 2 Factor Authentication (2FA) is now an optional 
capability which the CIAB Admin can easily install and it will automatically activate for use by CIAB 
users logging in afterwards.

NOTE: users will have to have a TOTP compatible application on their smart phones inorder to use TOTP. 
      Google Authenticator works well for this and is available on Android and iPhone.

This Installation Guide now has an added section describing the 4 steps required to create an 
IPP (Internet Printing Protocol) Printer in the CN1 CUPS (Common Unix Printing System) so users can 
print directly to their local printers if those printers support IPP and most modern printers do!

Lastly, the CIAB-README.PDF document now also contains a section titled “Steps to Implement a 
real/valid HTTPS/TLS Certificate for CIAB”. 

This section provides information and a Guide for how to obtain & install a valid Certificate 
from a Certificate Authority (LetsEncrypt) for use for HTTPS/TLS access to your CIAB installation.


\==================
v2.1 Release Notes
\==================

This update introduces the following improvements and new features.

Both file uploads and downloads now work between a Users local PC and their CIAB Remote Desktop system.

Entry of a Login ID and Password is now only required one time for both CIAB's Guacamole and the CIAB 
Remote Desktop connections.

If a CIAB User only has a single Remote Desktop connection configured for them they will be connected 
to that Desktop immediately after entering their User ID and Password.

**IMPORTANT NOTE**

    Please review the CIAB - README.pdf !

    The PDF has been significantly updated/improved in regards to not only the new features but also the 
    overall CIAB Installation & Configuration process!

    Some of the new capabilities (such as file download and only requiring Login ID and Password once) 
    will require some minor editing of existing CIAB Guacamole CIAB-GUAC and CN1 "connection" configurations 
    for the new capabilities to work correctly!

Also, note that I have started adding some short Tips into this Repository's "Issues" section to help 
with several topics.



\==================
v2.0 release notes
\==================

With CIAB Remote Desktop System v2.0 introduced several major enhancements!

CIAB has been updated with Guacamole v1.0.0 which was released January 2019. This version of Guacamole 
now supports many new capabilities such as:

    Support for user groups
    Multi-factor authentication with Google Authenticator / TOTP
    Support for RADIUS authentication
    Support for creating ad-hoc connections
    Support for renaming RDP drive and printer
    Cut & Paste for text-only (no pictures) now works as it normally would on a desktop
    Configurable terminal color schemes
    Optional recording of input events
    SSH host key verification
    Automatic detection of network issues
    Support for systemd
    Incorrect status reported for sessions closed by RDP server
    Automatic connection behavior which means Guacamole will automatically connect upon login for users 
    that have access to only a single connection, skipping the home screen.

A recent addition to the CIAB Remote Desktop are the *CIAB Web Applications*! 

Previously, this had to be installed separately after the CIAB Remote Desktop system had been installed.

With CIAB Remote Desktop System v2.0 this has now been integrated so that the CIAB Admin will see an Icon on their 
Mate Desktop when they log into the CIAB-GUAC LXD container desktop.

To install one or more of those CIAB Web Apps you just have to click on that Icon and when prompted select 
"RUN IN A TERMINAL" and after doing so you will be presented with a GUI Menu where you can Check the boxes 
for one or more Web Applications you'd like to install.

**NOTE**: These applications will be installed as peer LXD containers to the CIAB-GUAC and CN1 containers and they 
will all be attached to the same 10.x.x.x private network that the CIAB-GUAC and the CN1 containers are attached to. 

This use of the private 10.x.x.x network has greatly enhanced the security regarding using these Web Applications 
as only validated users with CIAB Accounts and a login on the CN1 Mate Desktop container will have access to those 
web applications unless the CIAB Admin allows access from the internet via a separate configuration requirement.

Read more about the CIAB Web Application later in the Section of this README titled "CIAB Web Applications".

These are a large group of Web based applications. Each selected application is installed in its own LXD container.

**Important Note**:

In this repository is a file called CIAB System Architecture Mindmap.pdf. 

If you download that PDF you can click on any bubble that has a small link icon in it to drill down/up in the map 
for further information. 

At the CIAB Applications level each Application bubble has a link icon and if you click on that bubble you will 
be taken to the Documentation webpage for that > particular Web Application.

With this update the CIAB Remote Desktop Admin components all run in an LXD Container called CIAB-GUAC.
This means Guacamole, MySQL, NGINX, Tomcat8, XRDP, XFreeRDP and the Ubuntu MATE desktop environment.

The end-user Desktops all run in a second LXD Container called CN1.

Installation time depends the chosen Server/Host's number/type of CPU, amount of RAM and type of disk (SSD or spinning).

**NOTE**: For example, on a Server with 4 core 8GB ram and an SSD disk drive the installation will take between 30-45 minutes.

After installation you can very easily add more remote desktop server containers either on the same LXD Host/Server or 
on another LXD Host/Server just by copying the existing CN1 container which only takes a 1-2 minutes:

    $ lxc copy cn1 cn2

This 2.0 version also utilizes the recently added new Device Proxy capability that maps Port 443 on your Host 
Server (cloud or VM) to an LXD container called ciab-guac (where guacamole etc gets installed). This means that after 
installation any CIAB Desktop user that points their Browser to the Host/Server will be redirected to the ciab-guac 
LXD container.

Since ciab-guac resides on the same private/internal 10.x.x.x subnet as the cn1 container and any additional containers
you clone from the original cn1, they can all inter-communicate with one another. 

Also, any CIAB Web Applications the Admin installs will also be attached to this same 10.x.x.x network allowing 
**only** validated CIAB Users logged into the Mate Desktop on CN1 to use their browser to access those applications.


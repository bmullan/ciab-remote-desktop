#!/bin/bash

# NOTE:  Execute this Script as SUDO or ROOT .. NOT as a normal UserID

# Check if user is root or sudo ... if NOT then exit and tell user.

if ! [ $(id -u) = 0 ]; then echo "Please run this script as either SUDO or ROOT !"; exit 1 ; fi


# Harden the ciab-remote-desktop using Nginx (i.e. reverse proxy with SSL) install nginx

sudo apt install nginx -y

# remove access via 8080 (tomcat old default)
sudo ufw delete allow 8080

# make a directory to hold SSL certs
sudo mkdir /etc/nginx/ssl 

# Define variables

ssl_country=US
ssl_state=NC
ssl_city=Raleigh
ssl_org=IT
ssl_certname=ciab.desktop.local
  
# Create a self-signed certificate

sudo openssl req -x509 -subj "/C=$ssl_country/ST=$ssl_state/L=$ssl_city/O=$ssl_org/CN=$ssl_certname" -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/guacamole.key -out /etc/nginx/ssl/guacamole.crt -extensions v3_ca

# stop nginx
sudo service nginx stop

# save current nginx config so we can add ours
sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bkp

sudo rm /etc/nginx/sites-enabled/default

#========================================================================  
# Add proxy settings to nginx config file (note the occasional backslash)

sudo cat <<EOF1 > /etc/nginx/sites-available/guacamole
# Accept requests via HTTP (TCP/80), but obligate all clients to use HTTPS (TCP/443)
server {
  listen 80;
  return 302 https://\$host\$request_uri;        ## You may want a 301 after testing is complete?
}
 
# Accept requests via HTTPS (TCP/443) then reverse-proxy to Guacamole via Tomcat (TCP/8080)
server {
  listen 443 ssl;
  server_name localhost;

  access_log   /var/log/nginx/guacamole.access.log ;
  error_log    /var/log/nginx/guacamole.error.log info ; 

  ssl_certificate /etc/nginx/ssl/guacamole.crt;
  ssl_certificate_key /etc/nginx/ssl/guacamole.key;


  ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers         HIGH:!aNULL:!MD5;

  location / {
      proxy_buffering off;
      proxy_pass  http://127.0.0.1:8080;

      # This is required to get WebSocket working
      proxy_http_version  1.1;

      # note:   
      # the "\" in the next line is an escape character which should not appear in the installed /etc/nginx/sites-enabled/default file
      # but is placed here in the script to insure that the text "$http_upgrade" DOES get included in the final "default" file

      proxy_set_header    Upgrade    \$http_upgrade;
      proxy_set_header    Connection "upgrade";
 
      # Logging access to Guacamole 'doesn't make sense' (but may be useful for debugging)
      access_log  off;
  }
}
EOF1

sudo ln -s /etc/nginx/sites-available/guacamole /etc/nginx/sites-enabled/guacamole

# restart nginx
sudo service nginx restart

echo "====================================================================================="
echo "                The installation of NGINX is complete!"
echo 
echo " Now you need to reboot your Server NOW before proceeding with the rest of the"
echo " CIAB Remote Desktop installation steps/scripts."
echo 
echo " Use the command ->   sudo shutdown -r now"
echo
echo " After the system reboots change directory back to /opt/ciab and then execute the"
echo " command:"
echo 
echo "          $ sudo ./setup-ciab.sh"
echo
echo "====================================================================================="
echo
echo







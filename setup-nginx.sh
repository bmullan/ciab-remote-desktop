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

# delete the 'default' file as a new one will be created
sudo rm /etc/nginx/sites-enabled/default

#==============================================================================================  
# Add proxy settings to nginx config file (note the occasional backslash used to escape the "$"
# character so "$" gets copied to the resulting file

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
      # entries here are modeled after the apache guacamole web page for nginx proxy
      # https://guacamole.apache.org/doc/gug/proxying-guacamole.html
      proxy_pass  http://127.0.0.1:8080;
      proxy_buffering off;
      # This is required to get WebSocket working
      proxy_http_version  1.1;
      #------------------------------------------------------------------------------------
      # NOTE: because we are using "sudo cat <<EOF1" to create this file entry (see above)
      # we need to escape the "$" so it gets included in the output to the target file
      #------------------------------------------------------------------------------------
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header    Upgrade    \$http_upgrade;
      proxy_set_header    Connection "upgrade";
      # Logging access to Guacamole 'doesn't make sense' so we leave this OFF but note that
      # it at some times might be useful for debugging purposes
      access_log  off;
  }
}
EOF1

sudo ln -s /etc/nginx/sites-available/guacamole /etc/nginx/sites-enabled/guacamole

# restart nginx
sudo service nginx restart








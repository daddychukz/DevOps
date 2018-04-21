#!/bin/sh
sudo add-apt-repository -y ppa:certbot/certbot
sudo apt-get update
sudo apt-get install python-certbot-nginx -y
sudo certbot --nginx --non-interactive --test-cert --redirect --agree-tos -d www.chuks-zone.com.ng -m durugo_chuks@yahoo.com
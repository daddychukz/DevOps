#!/bin/bash

# Script to deploy the app
# This file is needed only when you want to deploy the app to a Linux VM

# install node
pushd .
cd ~
git clone -b devops-fixes https://github.com/daddychukz/More-Recipes.git
curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
echo -------------------- installing nodejs --------------------------
sudo apt-get install nodejs -y

# install packages
echo ---------------- installing global packages --------------------
sudo npm install express -g
sudo npm install sequelize-cli -g
sudo npm install babel-cli -g

echo ---------------- installing npm packages -------------------------
pushd More-Recipes
sudo npm install --unsafe-perm

# set variables
echo ---------------- Setting environment variables ----------------------
export NODE_ENV=production
export configEnvVar=DATABASE_URL
export DATABASE_URL=postgres://wbxstbmq:1So1LMlT5dVMv8j9i4lLgbBZef7Czu4O@stampy.db.elephantsql.com:5432/wbxstbmq
export configDialect=postgres
export ClientId=1020610939165-pgmi2vuh8broeahhfo1v6vfqueb92sak.apps.googleusercontent.com
export CloudName=chuks-andela32
export SENDGRID_API_USER=daddychuks
export SENDGRID_API_PASSWORD=Christ111#
export SECRET=secret123
export UploadPreset=jdhszyow
export HOST=https://www.chuks-zone.com.ng
export swaggerJSON=https://www.chuks-zone.com.ng/swagger.json
export swaggerTitle="Chuks Recipes"
export swaggerVersion=1.0.0
export swaggerDescription="An Online Recipe management platform API Documentation"
export swaggerName="Durugo Chukwukadibia"
export swaggerUrl=https://www.chuks-zone.com.ng
export swaggerEmail=chukwukadibia.durugo@andela.com
export swaggerHost=https://www.chuks-zone.com.ng

# build files
echo --------------- building files --------------------
sudo npm run prestart
popd

# configure nginx
echo --------------- configuring nginx server -----------------
sudo cp -f /etc/nginx/sites-enabled/default nginx-default-server
sudo cp -f ./node-app-nginx-config /etc/nginx/sites-available/default
sudo ln -fs /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
sudo service nginx restart

#Download and configure Let's Encrypt Client
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install python-certbot-nginx
sudo certbot --nginx -d www.chuks-zone.com.ng

pushd More-Recipes
# install pm2 and start the node server as a daemon
echo ---------------- starting application ---------------------
sudo npm install pm2 -g -y
pm2 delete chuks-recipes -s
pm2 start Server/dist/app.js -n chuks-recipes

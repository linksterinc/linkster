# linkster
This code was forked and adapted from https://github.com/fazt/nodejs-mysql-links -- I've renamed it to "linkster" to make the names of things shorter.

# installing on a VM w/ separate database
_this installation method is intended for Cloud platforms; install the application on a stock VM and connect to either a database server on another VM, or use a DBaaS service_

_inspired by [this tutorial](https://www.sammeechward.com/deploying-full-stack-js-to-aws-ec2)_

## App server
Prerequisite: VM running Ubuntu or Debian

### install prereqs
```sh
sudo apt update
sudo apt upgrade

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### upload code
_Use whatever method is easiest for the service; e.g. if working in a Cloud Shell environment, there may be an "upload file" function_

Copy the contents of this folder (except for `node_modules` and `.git`) to ~/app on the app server.

Example:
```sh
rsync -avz --exclude 'node_modules' --exclude '.git' --exclude '.env' \
-e "ssh -i ~/cpet/azure-keys/linkster-2024-08-15_key.pem" \
. linkster@172.200.185.120:~/app
```

Install node deps:
```sh
cd ~/app
npm i
```

### configure app server as system daemon

```sh
sudo vim /etc/app.env
```

In Vim, add your variables in the format VARIABLE=value. For example:

`DB_PASSWORD=your_secure_password`

```sh
sudo chmod 600 /etc/app.env
sudo chown ubuntu:ubuntu /etc/app.env
```

```sh
sudo vim /etc/systemd/system/linkster.service
```
...paste this config:

```toml
[Unit]
Description=Node.js App
After=network.target multi-user.target

[Service]
User=linkster
WorkingDirectory=/home/linkster/app
ExecStart=/usr/bin/npm start
Restart=always
Environment=NODE_ENV=production
EnvironmentFile=/etc/app.env
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=linkster

[Install]
WantedBy=multi-user.target
```

```sh
sudo systemctl daemon-reload
sudo systemctl enable linkster.service
sudo systemctl start linkster.service
```

#### Verify that the service is running properly.
```sh
sudo systemctl status linkster.service
```

view logs:
```sh
sudo journalctl -u linkster.service
```

tail logs:
```sh
sudo journalctl -fu linkster.service
```

request the site and confirm that you get an html response:
```sh
curl localhost:8080
```

### configure reverse proxy with [Caddy](https://caddyserver.com/docs/install)
```
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy
sudo vim /etc/caddy/Caddyfile
```

Replace Caddyfile contents with
```json
:80 {
    reverse_proxy localhost:8080
}
```

```sh
sudo systemctl restart caddy
```

#### Verify that Caddy proxy is working
Navigate to http://<instance_public_ip> (assuming port 80 is open on firewall)

### configure TLS with Caddy
(Make a DNS A record pointing to your IP)

```sh
sudo vim /etc/caddy/Caddyfile
```

replace `:80` with your domain name:

```json
mydomain.com {
    reverse_proxy localhost:3000
}
```

```sh
sudo systemctl restart caddy
```

...it should be working! visit `https://<your_domain_name>` to confirm
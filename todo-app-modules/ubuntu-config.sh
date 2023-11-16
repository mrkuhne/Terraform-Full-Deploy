#!/bin/bash
exec >> /home/log.log 2>> /home/error.log

# Set Environment Variables
echo 'DB_URL=jdbc:mysql://${database_host}/${database_name}'                    | sudo tee -a /etc/environment
echo 'DB_USERNAME=${database_user}'                                             | sudo tee -a /etc/environment
echo 'DB_PASSWORD=${database_pass}'                                             | sudo tee -a /etc/environment

# Install upgrade ubuntu, apache2 and AWS CLI
sudo apt update -y
sudo apt upgrade -y
sudo apt install apache2 -y
sudo apt install awscli -y
sudo apt install jq -y
sudo apt install netcat -y

# Add SSH developer with password
sudo useradd developer
echo "developer:password"               | sudo chpasswd
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo "developer ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
sudo systemctl restart sshd

# Download JDK17 and install it on ubuntu
wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb
sudo dpkg -i jdk-17_linux-x64_bin.deb
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-17/bin/java                         

# Download application from s3 bucket and run the java app
[ -d "/home/todo_app" ] || sudo mkdir -p /home/todo_app
sudo aws s3 cp "s3://${bucket_name}/todo_app.jar" /home/todo_app/ --region eu-central-1

# Create systemd service file for the Java app with logging enabled
echo "[Unit]
Description=Todo Java App Service

[Service]
ExecStart=/usr/bin/java -jar /home/todo_app/todo_app.jar
Restart=always
User=ubuntu
EnvironmentFile=/etc/environment
StandardOutput=append:/var/log/todo_app_stdout.log
StandardError=append:/var/log/todo_app_stderr.log

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/todo_app.service > /dev/null

# Reload systemd, enable and start the service
sleep 30
sudo systemctl daemon-reload
sudo systemctl enable todo_app.service
sudo systemctl start todo_app.service

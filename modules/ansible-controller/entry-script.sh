#!/bin/bash
# Update package lists
sudo yum -y update

# Upgrade installed packages
sudo yum -y upgrade

#sudo yum install docker -y
#sudo service docker start 
#sudo usermod -aG docker ec2-user
#docker run -p 8080:80 nginx
sudo amazon-linux-extras install ansible2

sudo ansible-galaxy collection install amazon.aws
sudo ansible-galaxy collection install community.mysql

#sudo bash -c ' cat << EOF > /home/ec2-user/Ansible-Website-Project/inventory_aws_ec2.yaml
#plugin: aws_ec2
#regions:
#  - "us-east-2"
#keyed_groups:
#  - key: tags.Name
#filters:
#  instance-state-name: running
#compose:
#  ansible_host: public_ip_address
#EOF'
sudo bash -c "echo 'database_server_ip: ${db_public_ip_value}' >> /home/ec2-user/vars.yml"
sudo bash -c "echo 'web_server_ip: ${ws_public_ip_value}' >> /home/ec2-user/vars.yml"
sudo bash -c "echo 'prometheus_server_ip: ${ps_public_ip_value}' >> /home/ec2-user/vars.yml"
sudo bash -c "echo 'database_server_private_ip: ${db_private_ip_value}' >> /home/ec2-user/vars.yml"
sudo bash -c "echo 'prometheus_server_private_ip: ${ps_private_ip_value}' >> /home/ec2-user/vars.yml"
sudo bash -c "echo 'web_server_private_ip: ${ws_private_ip_value}' >> /home/ec2-user/vars.yml"

sudo yum install pip -y
sudo python3 -m pip install --upgrade pip 
sudo pip install boto3 botocore 








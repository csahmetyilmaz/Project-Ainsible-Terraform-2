#!/bin/bash
sudo yum update -y
#sudo yum install docker -y
#sudo service docker start 
#sudo usermod -aG docker ec2-user
#docker run -p 8080:80 nginx
sudo amazon-linux-extras install ansible2
sudo ansible-galaxy collection install amazon.aws
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
sudo yum install pip -y
sudo python3 -m pip install --upgrade pip 
sudo pip install boto3 botocore 





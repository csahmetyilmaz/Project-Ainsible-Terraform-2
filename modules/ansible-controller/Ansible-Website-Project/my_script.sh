#!/bin/bash


# Update package lists
sudo yum -y update

sudo yum install ncat -y

# AWS CLI kullanarak genel IP adreslerini al
ip_addresses=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].PrivateIpAddress' --output json)

# IP adreslerini ekrana yazdır
echo "IP Adresleri: $ip_addresses"

# IP adreslerini bir dosyaya yaz
echo "$ip_addresses" > ip_addresses.txt

# İlk IP adresini ayrıştır ve bir değişkene ata (örneğin, ilk_ip)
ws_private_ip=$(echo "$ip_addresses" | jq -r '.[0][0]')
echo "İlk IP Adresi: $ws_private_ip"

db_private_ip= $(echo "$ip_addresses" | jq -r '.[0][1]')
echo "İlk IP Adresi: $db_private_ip"

ps_private_ip=$(echo "$ip_addresses" | jq -r '.[0][2]')
echo "İlk IP Adresi: $ps_private_ip"

# Ncat'ı yükle
sudo yum install -y nmap-ncat


# Define variables
ansibleExecutable="/usr/bin/ansible-playbook"
inventoryFile="/home/ec2-user/Ansible-Website-Project/inventory_aws_ec2.yaml"
playbookFile1="/home/ec2-user/Ansible-Website-Project/WebServerConfiguration.yaml"
playbookFile2="/home/ec2-user/Ansible-Website-Project/DatabaseConfiguration.yaml"

# Wait for the EC2 instance to be ready (replace with your actual condition)

#ws_private_ip=$(terraform output -raw ws_private_ip)
#db_private_ip=$(terraform output -raw db_private_ip)
#ps_private_ip=$(terraform output -raw ps_private_ip)

# SSH bağlantisini belirli bir süre boyunca kontrol et
timeout 1m nc -z -v -w30 "${ws_private_ip}" 22 && echo 'SSH on Web Server is ready.'

timeout 1m nc -z -v -w30 "${db_private_ip}" 22 && echo 'SSH on Database Server is ready.'

timeout 1m nc -z -v -w30 "${ps_private_ip}" 22 && echo 'SSH on Proxy Server is ready.'

# Wait for the EC2 instance to be ready
timeout 5m $ansibleExecutable -i $inventoryFile $playbookFile1 && echo 'Ansible playbook for Web Server is completed.'

timeout 5m $ansibleExecutable -i $inventoryFile $playbookFile2 && echo 'Ansible playbook for Database Server is completed.'

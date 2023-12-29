#!/bin/bash

# Define variables
ansibleExecutable="/usr/bin/ansible-playbook"
inventoryFile="/home/ec2-user/Ansible-Website-Project/inventory_aws_ec2.yaml"
playbookFile1="/home/ec2-user/Ansible-Website-Project/WebServerConfiguration.yaml"
playbookFile2="/home/ec2-user/Ansible-Website-Project/DatabaseConfiguration.yaml"

# Wait for the EC2 instance to be ready (replace with your actual condition)
count=0
maxCount=30
sleepInterval=5
private_ip=${null_resource.ansible_controller.triggers.private_ip} #$(terraform output -raw private_ip)

while [ $count -lt $maxCount ]; do
    ((count++))
    result=$(nc -z -w 1 $private_ip 22 2>&1)
    if [ $? -eq 0 ]; then
        echo "SSH bağlantisi hazirr!"
        break
    fi

    echo "SSH bekleniyor... (Deneme $count / $maxCount)"
    sleep $sleepInterval
done

if [ $count -eq $maxCount ]; then
    echo "Süre doldu! SSH bağlantisi kurulamadi."
    exit 1
fi

# Run Ansible playbook
$ansibleExecutable -i $inventoryFile $playbookFile1
$ansibleExecutable -i $inventoryFile $playbookFile2
#!/bin/bash

# Resource Group Name
resourceGroupName="ResourceGroupSeven"
# Virtual Machine Name
vmName="nameVnSeven"
# Admin Username
adminUsername="adminvnseven"
# Admin Password
adminPassword="P@ssw0rd.123"

# Create Resource Group
az group create --name $resourceGroupName --location eastus
echo "Create Resource Group Done"

# Create Virtual Machine
az vm create \
    --resource-group $resourceGroupName \
    --name $vmName \
    --image UbuntuLTS \
    --admin-username $adminUsername \
    --admin-password $adminPassword \
    --authentication-type password \
    --size Standard_DS1_v2 \
    --generate-ssh-keys
echo "Create Virtual Machine Done"

# Open Port 80,443 for HTTP traffic
az vm open-port --port 80 --priority 900 --resource-group $resourceGroupName --name $vmName
az vm open-port --port 443 --priority 901 --resource-group $resourceGroupName --name $vmName
echo "Open Port 80, 443 for HTTP traffic Done"

# Install Apache Web Server
az vm run-command invoke \
    --resource-group $resourceGroupName \
    --name $vmName \
    --command-id RunShellScript \
    --scripts "sudo apt update && sudo apt install -y apache2"
echo "Install Apache Web Server Done"

# Start Apache Web Server
az vm run-command invoke \
    --resource-group $resourceGroupName \
    --name $vmName \
    --command-id RunShellScript \
    --scripts "sudo systemctl start apache2"
echo "Start Apache Web Server Done"

# Enable Apache Web Server to start on boot
az vm run-command invoke \
    --resource-group $resourceGroupName \
    --name $vmName \
    --command-id RunShellScript \
    --scripts "sudo systemctl enable apache2"
echo "Enable Apache Web Server to start on boot Done"
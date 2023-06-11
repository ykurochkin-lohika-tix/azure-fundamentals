#!/bin/bash

# Variables
resourceGroup="LBResourceGroup"
location="eastus"
availabilitySetName="LBAvailabilitySet"
vmSize="Standard_DS2_v2"
adminUsername="lbusername"
adminPassword="^x2lz@eX1bC8"
vnetName="LBVnet"
subnetName="LBSubnet"
publicIPName="LBPublicIP"
nic1Name="LBNIC1"
nic2Name="LBNIC2"
vm1Name="LBVM1"
vm2Name="LBVM2"
lbName="LB8"
lbPublicIPName="LB8PublicIP"
lbFrontEndIPName="LBF8rontEndIP"
lbProbeName="LB8Probe"
lbRuleName="LB8Rule"

echo Create a resource group
az group create --name $resourceGroup --location $location

echo Create an availability set
az vm availability-set create --name $availabilitySetName --resource-group $resourceGroup --location $location

echo Create a virtual network
az network vnet create --name $vnetName --resource-group $resourceGroup --location $location --address-prefixes 10.0.0.0/16 --subnet-name $subnetName --subnet-prefixes 10.0.0.0/24

echo Create NIC1
az network nic create --name $nic1Name --resource-group $resourceGroup --location $location --subnet $subnetName --vnet-name $vnetName --private-ip-address 10.0.0.4

echo Create VM1
az vm create --name $vm1Name --resource-group $resourceGroup --location $location --availability-set $availabilitySetName --nics $nic1Name --image UbuntuLTS --admin-username $adminUsername --admin-password $adminPassword --size $vmSize

echo Create NIC2
az network nic create --name $nic2Name --resource-group $resourceGroup --location $location --subnet $subnetName --vnet-name $vnetName --private-ip-address 10.0.0.5

echo Create VM2
az vm create --name $vm2Name --resource-group $resourceGroup --location $location --availability-set $availabilitySetName --nics $nic2Name --image UbuntuLTS --admin-username $adminUsername --admin-password $adminPassword --size $vmSize

echo Create a public IP address for the load balancer
az network public-ip create --name $lbPublicIPName --resource-group $resourceGroup --location $location --sku Standard

echo Create a load balancer
az network lb create --name $lbName --resource-group $resourceGroup --location $location --frontend-ip-name $lbFrontEndIPName --public-ip-address $lbPublicIPName --sku Standard

echo Create a health probe for the load balancer
az network lb probe create --name $lbProbeName --resource-group $resourceGroup --lb-name $lbName --protocol tcp --port 80 --interval 5 --threshold 2

echo Create a load balancing rule for the load balancer
az network lb rule create --name $lbRuleName --resource-group $resourceGroup --lb-name $lbName --protocol tcp --frontend-port 80 --backend-port 80 --frontend-ip-name $lbFrontEndIPName --probe-name $lbProbeName

echo Create a backend pool for the load balancer
az network lb address-pool create --name myBackendPool --resource-group $resourceGroup --lb-name $lbName

echo Associate the public IP address with the load balancer backend pool
az network nic ip-config update --name ipconfig1 --nic-name $nic1Name --resource-group $resourceGroup --lb-name $lbName --lb-address-pools myBackendPool

echo Associate the public IP address with the load balancer backend pool
az network nic ip-config update --name ipconfig1 --nic-name $nic2Name --resource-group $resourceGroup --lb-name $lbName --lb-address-pools myBackendPool

echo Create a front-end IP configuration for the load balancer
az network lb frontend-ip create --name $lbFrontEndIPName --resource-group $resourceGroup --lb-name $lbName --public-ip-address $lbPublicIPName

# echo "Open Port 80, 443 for HTTP traffic"
# az vm open-port --port 80 --priority 900 --resource-group $resourceGroup --name $vm1Name
# az vm open-port --port 80 --priority 901 --resource-group $resourceGroup --name $vm2Name

echo "Install Apache Web Server 1"
az vm run-command invoke \
    --resource-group $resourceGroup \
    --name $vm1Name \
    --command-id RunShellScript \
    --scripts "sudo apt update && sudo apt install -y apache2"

echo "Start Apache Web Server 1"
az vm run-command invoke \
    --resource-group $resourceGroup \
    --name $vm1Name \
    --command-id RunShellScript \
    --scripts "sudo systemctl start apache2"

# echo "Install Apache Web Server 2"
# az vm run-command invoke \
#     --resource-group $resourceGroup \
#     --name $vm2Name \
#     --command-id RunShellScript \
#     --scripts "sudo apt update && sudo apt install -y apache2"

# echo "Start Apache Web Server 2"
# az vm run-command invoke \
#     --resource-group $resourceGroup \
#     --name $vm2Name \
#     --command-id RunShellScript \
#     --scripts "sudo systemctl start apache2"
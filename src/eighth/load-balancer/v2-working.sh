#!/bin/bash

# Variables
resourceGroup="LBResourceGroup"
location="eastus"
adminPassword="^x2lz@eX1bC8"
vnetName="LBVnet"
lbBackendSubnet="LBBackendSubnet"
publicIPName="LBPublicIP"
lbName="LB8"
lbFrontEndIPName="LBF8rontEndIP"
lbProbeName="LB8Probe"
lbBackEndPool="LBBackEndPool"
lbNSG="LBNSG"

echo Create a resource group
az group create \
    --name $resourceGroup \
    --location $location

echo Create the virtual network
az network vnet create \
    --resource-group $resourceGroup \
    --location $location \
    --name $vnetName \
    --address-prefixes 10.1.0.0/16 \
    --subnet-name $lbBackendSubnet \
    --subnet-prefixes 10.1.0.0/24

echo Create a public IP address
az network public-ip create \
    --resource-group $resourceGroup \
    --name $publicIPName \
    --sku Standard \
    --zone 1 2 3

echo Create a load balancer

echo Create the load balancer resource
az network lb create \
    --resource-group $resourceGroup \
    --name $lbName \
    --sku Standard \
    --public-ip-address $publicIPName \
    --frontend-ip-name $lbFrontEndIPName \
    --backend-pool-name $lbBackEndPool

echo Create the health probe
az network lb probe create \
    --resource-group $resourceGroup \
    --lb-name $lbName \
    --name $lbProbeName \
    --protocol tcp \
    --port 80

echo reate the load balancer rule
az network lb rule create \
    --resource-group $resourceGroup \
    --lb-name $lbName \
    --name myHTTPRule \
    --protocol tcp \
    --frontend-port 80 \
    --backend-port 80 \
    --frontend-ip-name $lbFrontEndIPName \
    --backend-pool-name $lbBackEndPool \
    --probe-name $lbProbeName \
    --disable-outbound-snat true \
    --idle-timeout 15 \
    --enable-tcp-reset true

echo Create a network security group
az network nsg create \
    --resource-group $resourceGroup \
    --name $lbNSG

echo Create a network security group rule
az network nsg rule create \
    --resource-group $resourceGroup \
    --nsg-name $lbNSG \
    --name myNSGRuleHTTP \
    --protocol '*' \
    --direction inbound \
    --source-address-prefix '*' \
    --source-port-range '*' \
    --destination-address-prefix '*' \
    --destination-port-range 80 \
    --access allow \
    --priority 200

echo Create a bastion host

echo Create a public IP address
az network public-ip create \
    --resource-group $resourceGroup \
    --name myBastionIP \
    --sku Standard \
    --zone 1 2 3


echo Create a bastion subnet
az network vnet subnet create \
    --resource-group $resourceGroup \
    --name AzureBastionSubnet \
    --vnet-name $vnetName \
    --address-prefixes 10.1.1.0/27

echo Create bastion host
az network bastion create \
    --resource-group $resourceGroup \
    --name myBastionHost \
    --public-ip-address myBastionIP \
    --vnet-name $vnetName \
    --location $location

echo Create backend servers

echo Create network interfaces for the virtual machines
array=(myNicVM1 myNicVM2)
  for vmnic in "${array[@]}"
  do
    az network nic create \
        --resource-group $resourceGroup \
        --name $vmnic \
        --vnet-name $vnetName \
        --subnet $lbBackendSubnet \
        --network-security-group $lbNSG
  done

echo Create virtual machines
az vm create \
    --resource-group $resourceGroup \
    --name myVM1 \
    --nics myNicVM1 \
    --image win2019datacenter \
    --admin-username azureuser \
    --admin-password $adminPassword \
    --zone 1 \
    --no-wait

az vm create \
    --resource-group $resourceGroup \
    --name myVM2 \
    --nics myNicVM2 \
    --image win2019datacenter \
    --admin-username azureuser \
    --admin-password $adminPassword \
    --zone 2 \
    --no-wait

echo Add virtual machines to load balancer backend pool
array=(myNicVM1 myNicVM2)
  for vmnic in "${array[@]}"
  do
    az network nic ip-config address-pool add \
     --address-pool $lbBackEndPool \
     --ip-config-name ipconfig1 \
     --nic-name $vmnic \
     --resource-group $resourceGroup \
     --lb-name $lbName
  done


echo Create NAT gateway

echo Create public IP
az network public-ip create \
    --resource-group $resourceGroup \
    --name myNATgatewayIP \
    --sku Standard \
    --zone 1 2 3

echo Create NAT gateway resource
az network nat gateway create \
    --resource-group $resourceGroup \
    --name myNATgateway \
    --public-ip-addresses myNATgatewayIP \
    --idle-timeout 10

echo Associate NAT gateway with subnet
az network vnet subnet update \
    --resource-group $resourceGroup \
    --vnet-name $vnetName \
    --name $lbBackendSubnet \
    --nat-gateway myNATgateway

echo Install IIS
array=(myVM1 myVM2)
    for vm in "${array[@]}"
    do
     az vm extension set \
       --publisher Microsoft.Compute \
       --version 1.8 \
       --name CustomScriptExtension \
       --vm-name $vm \
       --resource-group $resourceGroup \
       --settings '{"commandToExecute":"powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"}'
  done

echo Test the load balancer
az network public-ip show \
    --resource-group $resourceGroup \
    --name $publicIPName \
    --query ipAddress \
    --output tsv
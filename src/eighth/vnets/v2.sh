#!/bin/bash

# Variables
resourceGroup="VNetResourceGroup7"
location="eastus"

echo Create a resource group
az group create --name $resourceGroup --location $location

echo Create VNET1
az network vnet create \
    --name VNET1 \
    --resource-group $resourceGroup \
    --address-prefixes 10.0.0.0/24 \
    --subnet-name Subnet1 \
    --subnet-prefixes 10.0.0.0/27

az network vnet subnet create \
    --name Subnet2-VNET1 \
    --vnet-name VNET1 \
    --resource-group $resourceGroup \
    --address-prefix 10.0.0.32/27

az network vnet subnet create \
    --name Subnet3-VNET1 \
    --vnet-name VNET1 \
    --resource-group $resourceGroup \
    --address-prefix 10.0.0.64/27

az network vnet subnet create \
    --name Subnet4-VNET1 \
    --vnet-name VNET1 \
    --resource-group $resourceGroup \
    --address-prefix 10.0.0.96/27

echo Create VNET2
az network vnet create \
    --name VNET2 \
    --resource-group $resourceGroup \
    --address-prefixes 10.0.1.0/24 \
    --subnet-name Subnet1-VNET2 \
    --subnet-prefixes 10.0.1.0/26

az network vnet subnet create \
    --name Subnet2-VNET2 \
    --vnet-name VNET2 \
    --resource-group $resourceGroup \
    --address-prefix 10.0.1.64/26

echo Create VNET3
az network vnet create \
    --name VNET3 \
    --resource-group $resourceGroup \
    --address-prefixes 10.0.2.0/24 \
    --subnet-name GatewaySubnet-VNET3 \
    --subnet-prefixes 10.0.2.0/27

az network vnet subnet create \
    --name Subnet2-VNET3 \
    --vnet-name VNET3 \
    --resource-group $resourceGroup \
    --address-prefix 10.0.2.32/28

az network vnet subnet create \
    --name Subnet3-VNET3 \
    --vnet-name VNET3 \
    --resource-group $resourceGroup \
    --address-prefix 10.0.2.48/28

echo Create VNET peerings
az network vnet peering create \
    --name VNET1-to-VNET2 \
    --resource-group $resourceGroup \
    --vnet-name VNET1 \
    --remote-vnet $(az network vnet show --resource-group $resourceGroup --name VNET2 --query id --out tsv) \
    --allow-vnet-access

az network vnet peering create \
    --name VNET1-to-VNET3 \
    --resource-group $resourceGroup \
    --vnet-name VNET1 \
    --remote-vnet $(az network vnet show --resource-group $resourceGroup --name VNET3 --query id --out tsv) \
    --allow-vnet-access

az network vnet peering create \
    --name VNET2-to-VNET1 \
    --resource-group $resourceGroup \
    --vnet-name VNET2 \
    --remote-vnet $(az network vnet show --resource-group $resourceGroup --name VNET1 --query id --out tsv) \
    --allow-vnet-access

az network vnet peering create \
    --name VNET3-to-VNET1 \
    --resource-group $resourceGroup \
    --vnet-name VNET3 \
    --remote-vnet $(az network vnet show --resource-group $resourceGroup --name VNET1 --query id --out tsv) \
    --allow-vnet-access
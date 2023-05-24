#!/bin/bash

# Set the variables for your environment
resourceGroup="ResourceGroupSeven"
nsgName="nameVnSevenNSG"
nicName="nameVnSevenVMNic"

# Define the NSG rule properties
ruleName="deny-port-80"
priority=800
destinationPortRange="80"
access="Deny"
protocol="Tcp"

# Create the NSG 80 port rule
az network nsg rule create \
  --resource-group $resourceGroup \
  --nsg-name $nsgName \
  --name $ruleName \
  --priority $priority \
  --destination-port-ranges $destinationPortRange \
  --access $access \
  --protocol $protocol
echo "Create the NSG 80 port rule Done"

# Define the NSG rule properties
ruleName1="deny-port-443"
priority1=801
destinationPortRange1="443"

# Create the NSG 443 port rule
az network nsg rule create \
  --resource-group $resourceGroup \
  --nsg-name $nsgName \
  --name $ruleName1 \
  --priority $priority1 \
  --destination-port-ranges $destinationPortRange1 \
  --access $access \
  --protocol $protocol
echo "Create the NSG 443 port rule Done"

# Update the NSG associated with the VM's network interface
az network nic update --resource-group $resourceGroup --name $nicName --network-security-group $nsgName
echo "Update the NSG associated with the VM's network interface Done"

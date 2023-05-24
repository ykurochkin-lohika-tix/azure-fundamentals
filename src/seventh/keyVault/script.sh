#!/bin/bash

# Variables
resourceGroupName="keyVaultResourceGroupSeven"
keyVaultName="keyVaultVmSeven"
passwordSecretName="passwordSecretVmSeven"
vmName="nameVnSeven"
vmPassword="P@ssw0rd.123"

# Create a resource group
az group create --name $resourceGroupName --location eastus

# Create an Azure Key Vault
az keyvault create --name $keyVaultName --resource-group $resourceGroupName --location eastus

# Store the password in the Key Vault as a secret
az keyvault secret set --vault-name $keyVaultName --name $passwordSecretName --value $vmPassword

# Create a virtual machine with the password retrieved from the Key Vault
az vm create --resource-group $resourceGroupName --name $vmName --image UbuntuLTS --admin-username azureuser --admin-password $(az keyvault secret show --vault-name $keyVaultName --name $passwordSecretName --query value -o tsv) --size Standard_DS2_v2 --public-ip-sku Standard --location eastus
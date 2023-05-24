#!/bin/bash

# Resource Group Name
resourceGroupName="ResourceGroupSeven"

az group delete --name $resourceGroupName --yes
echo "Delete Resource Group Done"
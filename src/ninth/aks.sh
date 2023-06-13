echo Create resource group
az group create --name mxnResourceGroup --location westus2

echo Create VNET and subnets

az network vnet create \
    --resource-group mxnResourceGroup \
    --name myVnet \
    --address-prefixes 10.0.0.0/8 \
    --subnet-name myAKSSubnet \
    --subnet-prefix 10.240.0.0/16

az network vnet subnet create \
    --resource-group mxnResourceGroup \
    --vnet-name myVnet \
    --name myVirtualNodeSubnet \
    --address-prefixes 10.241.0.0/16

# az network vnet subnet show --resource-group mxnResourceGroup --vnet-name myVnet --name myAKSSubnet --query id -o tsv

echo Create AKS cluster 
az aks create \
    --resource-group mxnResourceGroup \
    --name myAKSCluster \
    --node-count 1 \
    --network-plugin azure \
    --generate-ssh-keys \
    --node-vm-size Standard_B2s \
    --vnet-subnet-id /subscriptions/73b20800-141c-4cde-88d4-65181490b6ff/resourceGroups/mxnResourceGroup/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/myAKSSubnet

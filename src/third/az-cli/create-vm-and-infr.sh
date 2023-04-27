# Set variables
rgName="myResourceGroup"
location="eastus"
vmName="myVM"
vmSize="Standard_B1ls"
vmImage="UbuntuLTS"
adminUser="myadmin"
adminPassword="myPa$$w0rd12345"

# Create resource group
az group create --name $rgName --location $location

# Create virtual network and subnet
az network vnet create --name myVNet --resource-group $rgName --location $location --address-prefixes 10.0.0.0/16 --subnet-name mySubnet --subnet-prefixes 10.0.0.0/24

# Create public IP address
az network public-ip create --name myPublicIP --resource-group $rgName --location $location --sku Standard

# Create network security group
az network nsg create --name myNSG --resource-group $rgName --location $location

# Create network security group rule to allow SSH traffic
az network nsg rule create --name myNSGRuleSSH --nsg-name myNSG --resource-group $rgName --access Allow --protocol Tcp --direction Inbound --priority 1000 --source-address-prefix '*' --source-port-range '*' --destination-address-prefix '*' --destination-port-range 22

# Create virtual network interface
az network nic create --name myNIC --resource-group $rgName --location $location --subnet mySubnet --vnet-name myVNet --network-security-group myNSG --public-ip-address myPublicIP

# Create virtual machine
az vm create --resource-group $rgName --location $location --name $vmName --image $vmImage --size $vmSize --nics myNIC --admin-username $adminUser --admin-password $adminPassword

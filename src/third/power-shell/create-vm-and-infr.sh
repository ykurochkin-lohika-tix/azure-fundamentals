# Set variables
$rgName="powerResourceGroup"
$location="eastus"
$vmName="myVM"
$vmSize="Standard_B1ls"
$imagePublisher="Canonical"
$imageOffer="UbuntuServer"
$imageSKU="18.04-LTS"
$adminUser="myadmin"
$adminPassword="myPa$$w0rd12345"

# Create resource group
New-AzResourceGroup -Name $rgName -Location $location

# Create virtual network and subnet
$subnet = New-AzVirtualNetworkSubnetConfig -Name mySubnet -AddressPrefix "10.0.0.0/24"
$vnet = New-AzVirtualNetwork -Name myVNet -ResourceGroupName $rgName -Location $location -AddressPrefix "10.0.0.0/16" -Subnet $subnet

# Create public IP address
$publicIp = New-AzPublicIpAddress -Name myPublicIP -ResourceGroupName $rgName -Location $location -AllocationMethod Dynamic

# Create network security group
$nsg = New-AzNetworkSecurityGroup -Name myNSG -ResourceGroupName $rgName -Location $location

# Create network security group rule to allow SSH traffic
$nsgRule = New-AzNetworkSecurityRuleConfig -Name myNSGRuleSSH -Protocol Tcp -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 22 -Access Allow
$nsg | Add-AzNetworkSecurityRuleConfig -Name $nsgRule.Name -NetworkSecurityRuleConfig $nsgRule
$nsg | Set-AzNetworkSecurityGroup

# Create virtual network interface
$nic = New-AzNetworkInterface -Name myNIC -ResourceGroupName $rgName -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $publicIp.Id -NetworkSecurityGroupId $nsg.Id

# Create virtual machine
$vm = New-AzVMConfig -VMName $vmName -VMSize $vmSize | `
    Set-AzVMOperatingSystem -Linux -ComputerName $vmName -Credential (Get-Credential -UserName $adminUser -Message "Enter the password for the administrator account.") | `
    Set-AzVMSourceImage -PublisherName $imagePublisher -Offer $imageOffer -Skus $imageSKU -Version latest | `
    Add-AzVMNetworkInterface -Id $nic.Id | `
    Set-AzVMOSDisk -CreateOption FromImage | `
    New-AzVM -ResourceGroupName $rgName -Location $location -Verbose
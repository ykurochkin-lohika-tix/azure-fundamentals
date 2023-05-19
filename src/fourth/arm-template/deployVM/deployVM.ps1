 $resourceGroupName="pay-for-it-rg"
 $location="East US"
 $resourceExist=az group exists -n  $resourceGroupName
if ($resourceExist -eq "false")
{
    Write-Host "Resource group do not exist"
	Write-Host "Create new resource group "$resourceGroupName
	az group create -l $location -n $resourceGroupName
}
	New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -Location $location -TemplateFile azuredeploy.json -TemplateParameterFile azuredeploy.parameters.json
	az vm extension set --resource-group $resourceGroupName --vm-name "" --name customScript --publisher Microsoft.Azure.Extensions --settings ./script-config.json
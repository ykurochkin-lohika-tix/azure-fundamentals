# Set the resource group name
$resourceGroupName = "powerResourceGroup"

# Get all the resources in the resource group
$resources = Get-AzResource -ResourceGroupName $resourceGroupName

# Display the resources
foreach ($resource in $resources) {
    Write-Output "Resource name: $($resource.Name)"
    Write-Output "Resource type: $($resource.Type)"
    Write-Output "Resource location: $($resource.Location)"
    Write-Output "----------------------"
}
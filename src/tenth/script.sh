
# Create a service principal, authenticate az cli or powershell with it, run any command
#!/bin/bash
# Create a service principal with required parameter
echo Create a service principal for a resource group using a preferred name and role
az ad sp create-for-rbac --name servicePrincipalUser \
                         --role reader \
                         --scopes /subscriptions/73b20800-141c-4cde-88d4-65181490b6ff/resourceGroups/servicePrincipal

# Run your desired Azure CLI command
echo For example, list resource groups
az group list


# !!!! az ad sp create-for-rbac - Insufficient privileges to complete the operation.
# But I dont have an access to the Active Directory, so I cant create a any memeber in it. that can be used to create a service principal.
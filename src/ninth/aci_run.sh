echo Create and run the container
# az container create --resource-group mxnResourceGroup --name mycontainer \
# --image mxn06062023.azurecr.io/mxnsample:v1 --dns-name-label mxn-demo --ports 80

az container create --resource-group mxnResourceGroup --name mycontainer \
--image mxn06062023.azurecr.io/mxnsample:v1 --dns-name-label mxn-demo --ports 80 \
--registry-login-server mxn06062023.azurecr.io \
--registry-password anonymous \
--registry-username anonymous

echo Get info 
az container show --resource-group mxnResourceGroup --name mycontainer --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" --out table

#echo See logs 
# az container logs --resource-group mxnResourceGroup --name mycontainer

# echo Attach
# az container attach --resource-group mxnResourceGroup --name mycontainer

# echo Delete
# az container delete --resource-group mxnResourceGroup --name mycontainer
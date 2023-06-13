echo Azure Container Instances

echo Create a container registry and allow anonymous pull
az acr create --resource-group mxnResourceGroup \
  --name mxn06062023 --sku Standard 

# az acr delete --resource-group mxnResourceGroup \
#   --name mxn06062023

az acr update --name mxn06062023 --anonymous-pull-enabled

echo Build and push image from a Dockerfile
az acr build --image mxnsample:v1 \
  --registry mxn06062023 \
  --file Dockerfile .
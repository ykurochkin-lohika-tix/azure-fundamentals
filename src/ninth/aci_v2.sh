echo change index.html and build v2 
az acr build --image mxnsample:v2 \
  --registry mxn06062023 \
  --file Dockerfile . 
echo Enable virtual kubelet
az aks enable-addons \
    --resource-group mxnResourceGroup \
    --name myAKSCluster \
    --addons virtual-node \
    --subnet-name myVirtualNodeSubnet

echo Connect kubelet to cluster
az aks get-credentials --resource-group mxnResourceGroup --name myAKSCluster
# echo Create deployment
# kubectl create deployment my-dep --image=mxn06062023.azurecr.io/mxnsample:v1 --replicas=2

# echo Expose deployment
# kubectl expose deployment my-dep --type=LoadBalancer --port=80 --target-port=80
# kubectl get services

# . See deployment history
# kubectl rollout history deployment/my-dep

# 8. Update image
# kubectl set image deployment/my-dep mxnsample=mxn06062023.azurecr.io/mxnsample:v2 --record

# 9. Rollback
# kubectl rollout undo deployment/my-dep

# 10. Put a pod on virtual-node
# kubectl apply -f virtual-node.yaml

# kubectl get pods -o wide
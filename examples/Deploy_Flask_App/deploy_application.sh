kubectl get nodes
kubectl apply -f deployment.yml

# Verify the deployment
kubectl get deployments
# Check the rollout status
kubectl rollout status deployment/simple-flask-deployment
# IMPORTANT: Show the service, nodes, and pods in the cluster
# You will notice that the service does not have an external IP
kubectl get svc,nodes,pods
# Show the services in the cluster
kubectl describe services
# Display information about the cluster
kubectl cluster-info

# List all namespaces, all pods
kubectl get all -A
# Show all events
kubectl get events -w
# Show component status
kubectl get componentstatuses



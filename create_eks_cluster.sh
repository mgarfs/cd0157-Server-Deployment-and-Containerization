eksctl create cluster --name simple-jwt-api --nodes=2 --version=1.23 --instance-types=t2.medium --region=us-east-2
# aws eks update-kubeconfig --name simple-jwt-api --region us-east-2
# kubectl get nodes

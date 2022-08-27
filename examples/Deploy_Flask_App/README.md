
# TODO

Run from the cd0157-Server-Deployment-and-Containerization/examples/Deploy_Flask_App directory

- create cluster - cf. `create_cluster.sh`
- create docker hub repository - done - todo: `docker push mgarfs/simple-flask:<tagname>`
- update `deployment.yml` - image: - done
- Dockerhub login from terminal (mgarfs is my DockerHub username):
`docker login -u mgarfs`
- Dockerhub push:
`docker push mgarfs/simple-flask:latest`
- deploy application - cf. `deploy_application.sh`
- expose applicatoin: 
`kubectl expose deployment simple-flask-deployment --type=LoadBalancer --name=my-service`

Clean-up

- delete deployment:
`kubectl delete deployments/simple-flask-deployment`
- tear down cluster:
`eksctl delete cluster eksctl-demo --region=us-east-2`

CloudFormation

- create new stack:
`aws cloudformation create-stack  --stack-name myFirstTest --region us-east-1 --template-body file://myFirstTemplate.yml`
- update existing stack:
aws cloudformation update-stack  --stack-name myFirstTest --region us-east-1 --template-body file://myFirstTemplate.yml
- describe stack:
`aws cloudformation describe-stacks --stack-name myFirstTest`
- delete stack:
`aws cloudformation delete-stack --stack-name myFirstTest`


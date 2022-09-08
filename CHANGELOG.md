
## Prerequisites

* Docker Desktop - DONE
* Git - DONE
* VS code - DONE
* AWS Acccount - DONE - from Udacity
* Python version between 3.7 and 3.9 - DONE - `Python 3.8.10`
* Python package manager - PIP 19.x or higher - DONE - `pip 22.2.2`
* Terminal - DONE -  Ubuntu on Windows (WSL)
* AWS CLI - DONE - `aws configure set region us-east-2`
* EKSCTL - DONE - `0.109.0` 
* KUBECTL - DONE - The one that follows with Docker Desktop! - `v1.24.2`
  --!!! THIS DID NOT WORK - HAD TO INSTALL OWN VERSION OF KUBECTL !!!--
  `sudo apt-get install -y kubectl=1.22.0-00 --allow-downgrades`


## Intial setup
1. Fork https://github.com/udacity/cd0157-Server-Deployment-and-Containerization - DONE
2. Clone https://github.com/mgarfs/cd0157-Server-Deployment-and-Containerization - DONE
   cd cd0157-Server-Deployment-and-Containerization - DONE
3. Files with ToDos
```
-rw-r--r-- 1 micha micha   552 Aug 24 14:35 Dockerfile
-rwxr-xr-x 1 micha micha  4195 Aug 24 14:35 README.md
-rw-r--r-- 1 micha micha   716 Aug 24 14:35 aws-auth-patch.yml
-rw-r--r-- 1 micha micha  2789 Aug 24 14:35 buildspec.yml
-rwxr-xr-x 1 micha micha 11920 Aug 24 14:35 ci-cd-codepipeline.cfn.yml
-rw-r--r-- 1 micha micha   167 Aug 24 14:35 iam-role-policy.json
-rwxr-xr-x 1 micha micha  3016 Aug 24 14:35 main.py
-rwxr-xr-x 1 micha micha   142 Aug 24 14:35 requirements.txt
-rw-r--r-- 1 micha micha   772 Aug 24 14:35 simple_jwt_api.yml
-rw-r--r-- 1 micha micha   965 Aug 24 14:35 test_main.py
-rw-r--r-- 1 micha micha   246 Aug 24 14:35 trust.json

README.md:+-- aws-auth-patch.yml #ToDo
README.md:+-- buildspec.yml      #ToDo
README.md:+-- ci-cd-codepipeline.cfn.yml #ToDo
README.md:+-- iam-role-policy.json  #ToDo
README.md:+-- test_main.py  #ToDo
README.md:+-- trust.json     #ToDo
```
\- READY

### File instructions

Most of the files needed in this project are already available to you. You will have to make changes in the following files aligned with the upcoming instructions:

* `trust.json`: This file and `iam-role-policy.json` file will be used for creating an IAM role for Codebuild to assume while building your code and deploying to the EKS cluster.
* `aws-auth-patch.yml`: You will create a file similar to this one after creating en EKS cluster. We have given you a sample file so that the YAML indentations will not trouble you.
* `ci-cd-codepipeline.cfn.yml`: This is the Cloudformation template that we will use to create Codebuild, Codepipeline, and related resources like IAM roles and S3 bucket. This file is almost complete, except for you to write a few parameter values specific to you. Once the Codebuild resource is created, it will run the commands mentioned in the `buildspec.yml`.
* `test_main.py`: You will write unit tests in this file.


## Project Steps

Completing the project involves several steps:

### 1. Write a Dockerfile for a simple Flask API - DONE

The Flask app that will be used for this project consists of a simple API with three endpoints:

- `GET '/'`: This is a simple health check, which returns the response 'Healthy'.
- `POST '/auth'`: This takes an email and password as json arguments and returns a JWT based on a custom secret.
- `GET '/contents'`: This requires a valid JWT, and returns the decrypted contents of that token.

The app relies on a secret set as the environment variable `JWT_SECRET` to produce a JWT. The built-in Flask server is adequate for local development, but not production, so you will be using the production-ready **Gunicorn** server when deploying the app.

* Install dependencies - DONE - `pip3 install -r requirements.txt`
* Start the app - DONE - cf. `run_app.sh`
* Install jq - DONE - `jq-1.6`
* Check the app - use - DONE

   `curl --request GET http://localhost:8080/`

   <code>export TOKEN=\`curl --data '{"email":"abc@xyz.com","password":"mypwd"}' --header "Content-Type: application/json" -X POST localhost:8080/auth  | jq -r '.token'\`</code>

   `echo $TOKEN`

   `curl --request GET 'http://localhost:8080/contents' -H "Authorization: Bearer ${TOKEN}" | jq .`

```
$ curl --request GET http://localhost:8080/
"Healthy"
$ export TOKEN=`curl --data '{"email":"abc@xyz.com","password":"mypwd"}' --header "Content-Type: application/json" -X POST localhost:8080/auth  | jq -r '.token'`
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   217  100   175  100    42   170k  42000 --:--:-- --:--:-- --:--:--  211k
$ echo $TOKEN
eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NjI4MjY1OTIsIm5iZiI6MTY2MTYxNjk5MiwiZW1haWwiOiJhYmNAeHl6LmNvbSJ9.elgO9d_ahpItNTsVVWUOA22zj1q-xRMnLTfKH0To2CU
$ curl --request GET 'http://localhost:8080/contents' -H "Authorization: Bearer ${TOKEN}" | jq .
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    73  100    73    0     0  73000      0 --:--:-- --:--:-- --:--:-- 73000
{
  "email": "abc@xyz.com",
  "exp": 1662826592,
  "nbf": 1661616992
}
```

### 2. Build and test the container locally - DONE

* Check `Dockerfile` - DONE - **changed to use python 3.8 like local**
* Create `.env_file` - DONE
* Check `.gitignore` - DONE 
* Start Docker Desktop service - DONE
* Build an image - DONE - `docker build -t myimage .`
* Create and run a container - DONE - `docker run --name myContainer --env-file=.env_file -p 80:8080 myimage`
* Repeat app check from above but on port 80 - DONE


### 3. Create an EKS cluster - DONE

Start with creating an EKS cluster in your preferred region, using eksctl command. Create an IAM role that the Codebuild will assume to access your k8s/EKS cluster. This IAM role will have the necessary access permissions (attached JSON policies). Add IAM Role to the Kubernetes cluster's configMap.

* Create an EKS Cluster - DONE - cf. `create_eks_cluster.sh`

```
kubectl get nodes
error: You must be logged in to the server (Unauthorized)
```

https://github.com/kubernetes-sigs/aws-iam-authenticator/issues/174

https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html

```
export AWS_ACCESS_KEY_ID=<KEY>
export AWS_SECRET_ACCESS_KEY=<SECRET-KEY>
aws-iam-authenticator token -i <cluster-name>

aws-iam-authenticator verify -t <k8s-aws-v1.really_long_token> -i <cluster-name>

kubectl get nodes
NAME                                          STATUS   ROLES    AGE   VERSION
ip-192-168-32-94.us-east-2.compute.internal   Ready    <none>   12m   v1.23.9-eks-ba74326
ip-192-168-81-8.us-east-2.compute.internal    Ready    <none>   12m   v1.23.9-eks-ba74326
```

* IAM Role for CodeBuild - STEPS:

  - Get your AWS account id - DONE - `aws sts get-caller-identity --query Account --output text`
  - Update `trust.json` file - DONE
  - Create a role, 'UdacityFlaskDeployCBKubectlRole' - DONE - `aws iam create-role --role-name UdacityFlaskDeployCBKubectlRole --assume-role-policy-document file://trust.json --output text --query 'Role.Arn'`
    
    `arn:aws:iam::319372512713:role/UdacityFlaskDeployCBKubectlRole`

  - Attach the iam-role-policy.json policy to the 'UdacityFlaskDeployCBKubectlRole' - DONE - `aws iam put-role-policy --role-name UdacityFlaskDeployCBKubectlRole --policy-name eks-describe --policy-document file://iam-role-policy.json`

* Authorize the CodeBuild using EKS RBAC - STEPS:

  - Fetch - Get the current configmap and save it to a file - DONE - `kubectl get -n kube-system configmap/aws-auth -o yaml > /tmp/aws-auth-patch.yml`
  - Edit - Open the `aws-auth-patch.yml` file using any editor - DONE - `gvim /tmp/aws-auth-patch.yml`

```
  - groups:
    - system:masters
    rolearn: arn:aws:iam::<ACCOUNT_ID>:role/UdacityFlaskDeployCBKubectlRole
    username: build 
```

  - Update - Update your cluster's configmap - DONE - `kubectl patch configmap/aws-auth -n kube-system --patch "$(cat /tmp/aws-auth-patch.yml)"`

    `configmap/aws-auth patched`

### 4. Store a secret using AWS Parameter Store

* Save a Secret in AWS Parameter Store - DONE - 
```
aws ssm put-parameter --name JWT_SECRET --overwrite --value "myjwtsecret" --type SecureString
{
    "Version": 1,
    "Tier": "Standard"
}

aws ssm get-parameter --name JWT_SECRET
{
    "Parameter": {
        "Name": "JWT_SECRET",
        "Type": "SecureString",
        "Value": "AQICAHjFn83p/zONLoIw5hSasXP7gYm+t/4NdjFfQ6Tb0boHhwEuxobOM66JoQGJ9cEct5/qAAAAaTBnBgkqhkiG9w0BBwagWjBYAgEAMFMGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMQ5hm8zOxYsp4q9oCAgEQgCaC/7TF5CqjnbQDdxMcA1Ro06D3yfqmO6cay5RAAugvBSoQ22eBjg==",
        "Version": 1,
        "LastModifiedDate": "2022-09-08T22:31:21.253000+02:00",
        "ARN": "arn:aws:ssm:us-east-2:319372512713:parameter/JWT_SECRET",
        "DataType": "text"
    }
}
```

### 5. Create a CodePipeline pipeline triggered by GitHub checkins - DONE

* Generate a Github access token - DONE

* Create Codebuild and CodePipeline resources using CloudFormation template - STEPS:

  - Modify the template - DONE - `gvim ci-cd-codepipeline.cfn.yml`
  - Review the resources - DONE
  - Create Stack - DONE 

### 6. Create a CodeBuild stage which will build, test, and deploy your code

* Configure `buildspec.yml` - DONE


* Build and deploy
* Finally, you will trigger the build based on a Github commit.



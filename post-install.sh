#!/bin/bash

curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin

source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.

wget https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.3.0/heptio-authenticator-aws_0.3.0_linux_amd64
chmod +x heptio-authenticator-aws_0.3.0_linux_amd64
sudo mv heptio-authenticator-aws_0.3.0_linux_amd64 /usr/local/bin/heptio-authenticator-aws

sudo apt install -y python3-pip awscli && pip3 install --upgrade --user awscli


mkdir -p ~/.kube
terraform output kubeconfig > ~/.kube/config

aws eks --region us-east-1 update-kubeconfig --name terraform-eks-demo

terraform output config-map-aws-auth > ~/config-map-aws-auth.yaml
kubectl apply -f ~/config-map-aws-auth.yaml

kubectl create ns user-1
kubectl create ns user-2

kubectl create role user-1 --resource=* --verb=* -n user-1
kubectl create role user-2 --resource=* --verb=* -n user-2

kubectl create rolebinding user-1 --role=user-1 --user=user-1 -n user-1
kubectl create rolebinding user-2 --role=user-2 --user=user-2 -n user-2

##update configmap....






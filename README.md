# Kubeflow Vanilla
This project describes the process of deploying Kubeflow on an Amazon Elastic Kubernetes Service (EKS) cluster. The resources used in this project are deployed in the `eu-west-1` region but you can use any region of your choice.

This is **not** a production ready implementation of Kubeflow. A more appropriate way of deploying Kubeflow for production use cases would be to make use of Amazon Cognito which is described [here](https://www.kubeflow.org/docs/aws/aws-e2e/).

## Prerequisites
- AWS Command Line Interface (CLI)
- eksctl
- kfctl

Before proceeding, create an AWS CLI profile the AWS user that has the credential to interact with the AWS account you will use to deploy the resources. This is good practice if you are interacting with multiple AWS accounts/credentials.

## 1. EKS Cluster Creation
The EKS cluster can be created with the `eksctl` CLI tool by running the following command:
```
eksctl create cluster -f eks_cluster.yaml --profile nial-daly-cli
```

which references the `eks_cluster.yaml` manifest file. The Kubeflow deployment will also share the name of the EKS cluster that will be created.

## 2. Kubeflow Deployment
To deploy Kubeflow on the EKS cluster, enter the `kubeflow-platform/` directory and run:
```
sh deploy_kubeflow.sh
```

The `kfctl_aws.v1.2.0.yaml` manifest file is simply a reference to the manifest that is modified using the environment variables and applied with the `deploy_kubeflow.sh` script.

## 3. Resource Cleanup


## Additional Resources
- [EKS Workshop](https://www.eksworkshop.com)
- [Kubeflow v1.2.0 Manifest](https://github.com/kubeflow/manifests/blob/master/kfdef/kfctl_aws.v1.2.0.yaml)

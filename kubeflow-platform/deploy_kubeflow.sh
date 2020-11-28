#!/bin/sh

# Sets AWS region
export AWS_REGION=eu-west-1

# Sets the AWS CLI profile
export AWS_PROFILE=nial-daly-cli

# Obtain Kubeflow username and password from AWS Systems Manager Parameter Store
export KFLOW_USERNAME=
export KFLOW_PASSWORD=


# Adds the environment variables and dynamically generates the kubeflow manifest file
cat << EOF > kubeflow_manifest.yaml
apiVersion: kfdef.apps.kubeflow.org/v1
kind: KfDef
metadata:
  namespace: kubeflow
spec:
  applications:
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: namespaces/base
    name: namespaces
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: application/v3
    name: application
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: stacks/aws/application/istio-1-3-1-stack
    name: istio-stack
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: stacks/aws/application/cluster-local-gateway-1-3-1
    name: cluster-local-gateway
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: istio/istio/base
    name: istio
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: stacks/aws/application/cert-manager-crds
    name: cert-manager-crds
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: stacks/aws/application/cert-manager-kube-system-resources
    name: cert-manager-kube-system-resources
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: stacks/aws/application/cert-manager
    name: cert-manager
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: metacontroller/base
    name: metacontroller
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: stacks/aws/application/oidc-authservice
    name: oidc-authservice
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: stacks/aws/application/dex-auth
    name: dex
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: admission-webhook/bootstrap/overlays/application
    name: bootstrap
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: spark/spark-operator/overlays/application
    name: spark-operator
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: stacks/aws
    name: kubeflow-apps
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: aws/istio-ingress/base_v3
    name: istio-ingress
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: knative/installs/generic
    name: knative
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: kfserving/installs/generic
    name: kfserving
  - kustomizeConfig:
      repoRef:
        name: manifests
        path: stacks/aws/application/spartakus
    name: spartakus
  plugins:
  - kind: KfAwsPlugin
    metadata:
      name: aws
    spec:
      auth:
        basicAuth:
          password: 12341234
          username: admin@kubeflow.org
      region: us-west-2
      enablePodIamPolicy: true
      # If you don't use IAM Role for Service Account, you can still use node instance roles.
      #roles:
      #- eksctl-kubeflow-aws-nodegroup-ng-a2-NodeInstanceRole-xxxxxxx
  repos:
  - name: manifests
    uri: https://github.com/kubeflow/manifests/archive/v1.2-branch.tar.gz
  version: v1.2-branch
EOF

# Deploys Kubeflow on the EKS cluster
kfctl build -f kubeflow_manifest.yaml -V
kfctl apply -f kubeflow_manifest.yaml -V
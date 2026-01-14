# helm-aws-cert-manager

Installs cert-manager with AWS Pod Identity for Route53 DNS01 challenges.

## Overview

Composes the base `helm.hops.ops.com.ai/CertManager` XRD with `aws.hops.ops.com.ai/PodIdentity`.
Automatically provisions IAM role and Pod Identity association for cert-manager's service account.

## Usage

```yaml
apiVersion: helm.aws.hops.ops.com.ai/v1alpha1
kind: CertManager
metadata:
  name: cert-manager
  namespace: default
spec:
  clusterName: my-cluster
  aws:
    region: us-east-1
```

With custom values:

```yaml
apiVersion: helm.aws.hops.ops.com.ai/v1alpha1
kind: CertManager
metadata:
  name: cert-manager
  namespace: default
spec:
  clusterName: production-cluster
  namespace: cert-manager
  values:
    prometheus:
      enabled: true
  aws:
    region: us-west-2
    rolePrefix: prod-
```

## What Gets Created

1. `helm.hops.ops.com.ai/CertManager` - the base cert-manager Helm release
2. `aws.hops.ops.com.ai/PodIdentity` - IAM role + Pod Identity association with Route53 permissions

## Development

```bash
make render
make validate
make test
```

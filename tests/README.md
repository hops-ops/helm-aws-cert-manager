# Tests

## Unit Tests (test-render)

Validates composition logic without deploying resources.

```bash
make render   # Run composition render tests
make test     # Run all unit tests
```

## E2E Tests (e2etest-certmanager)

Full integration test that deploys real AWS infrastructure:
1. Creates Network (VPC/subnets via IPAM)
2. Creates AutoEKSCluster
3. Deploys helm.aws CertManager (cert-manager + AWS Pod Identity)

### Prerequisites

1. Create `tests/e2etest-certmanager/secrets/aws-creds` with AWS credentials:
   ```ini
   [default]
   aws_access_key_id = AKIA...
   aws_secret_access_key = ...
   ```

2. Ensure IPAM pool exists in the test account

### Running E2E Tests

```bash
make e2e      # Run full e2e test (~90 min for EKS creation)
```

**Note**: E2E tests create real AWS resources and can take up to 90 minutes to complete.

# e2etest-certmanager - helm.aws CertManager E2E Test
# ====================================================
# Tests installation of cert-manager with AWS Pod Identity for Route53 DNS01 challenges.
#
# This test creates:
# 1. An AutoEKSCluster using subnet IDs from the persistent hops-test network
# 2. A helm.aws CertManager that composes:
#    - helm.hops.ops.com.ai/CertManager (base Helm release)
#    - aws.hops.ops.com.ai/PodIdentity (IAM role + Pod Identity for Route53)
#
# Uses persistent network infrastructure from aws-network e2e test (hops-test)
# to speed up test execution by avoiding network creation/deletion.
#
# Prerequisites:
# 1. Create secrets/aws-creds file with AWS credentials in INI format:
#    [default]
#    aws_access_key_id = AKIA...
#    aws_secret_access_key = ...
#
# 2. Ensure the persistent hops-test network exists (from aws-network e2e test)
#
# 3. Run: make e2e

import base64
import file
import datetime
import math
import models.io.upbound.dev.meta.v1alpha1 as metav1alpha1

# Read AWS credentials from local file (gitignored)
_creds = file.read("secrets/aws-creds")
_base64_creds = base64.encode(_creds)

# =============================================================================
# Test Configuration
# =============================================================================
_now = str(int(math.floor(datetime.ticks())))
_test_name = "e2e-cm-" + _now
_namespace = "default"
_region = "us-east-2"
_account_id = "034489662075"  # CI test account

# =============================================================================
# Persistent Network Infrastructure (from aws-network e2e test - hops-test)
# =============================================================================
# Private subnet IDs for the EKS cluster - these are already created and orphaned
_private_subnet_ids = [
    "subnet-0ba2f584c25e9435d"  # private-a
    "subnet-02e4d512f8859e684"  # private-b
]

_items = [
    metav1alpha1.E2ETest {
        metadata.name = "certmanager"
        spec = {
            crossplane = {
                version = "2.0.2-up.5"
                autoUpgrade.channel = "None"
            }
            defaultConditions = ["Ready"]
            timeoutSeconds = 5400  # 90 minutes for EKS cluster creation
            cleanupTimeoutSeconds = 1800  # 30 minutes for cleanup
            skipDelete = False

            # initResources: Install infrastructure Configuration packages
            # Note: helm-cert-manager and aws-pod-identity are auto-installed as dependencies
            initResources = [
                # aws-auto-eks-cluster Configuration package (provides AutoEKSCluster XRD)
                {
                    apiVersion = "pkg.crossplane.io/v1"
                    kind = "Configuration"
                    metadata = {
                        name = "aws-auto-eks-cluster"
                    }
                    spec = {
                        package = "ghcr.io/hops-ops/aws-auto-eks-cluster:v0.1.0"
                    }
                }
            ]

            # extraResources: Credentials and ProviderConfigs (not deleted during cleanup)
            extraResources = [
                # AWS credentials secret
                {
                    apiVersion = "v1"
                    kind = "Secret"
                    metadata = {
                        name = "aws-creds"
                        namespace = _namespace
                    }
                    data = {
                        creds = _base64_creds
                    }
                }
                # AWS ProviderConfig using Secret credentials
                {
                    apiVersion = "aws.m.upbound.io/v1beta1"
                    kind = "ProviderConfig"
                    metadata = {
                        name = "default"
                        namespace = _namespace
                    }
                    spec = {
                        credentials = {
                            source = "Secret"
                            secretRef = {
                                namespace = _namespace
                                name = "aws-creds"
                                key = "creds"
                            }
                        }
                    }
                }
            ]

            # manifests: All XRs that need cleanup (AutoEKSCluster, CertManager)
            # Note: Uses persistent hops-test network - no Network manifest needed
            manifests = [
                # 1. AutoEKSCluster - uses subnet IDs from persistent hops-test network
                {
                    apiVersion = "aws.hops.ops.com.ai/v1alpha1"
                    kind = "AutoEKSCluster"
                    metadata = {
                        name = _test_name
                        namespace = _namespace
                    }
                    spec = {
                        clusterName = _test_name
                        region = _region
                        accountId = _account_id
                        version = "1.34"
                        subnetIds = _private_subnet_ids
                        providerConfigRef = {
                            name = "default"
                            kind = "ProviderConfig"
                        }
                        tags = {
                            "e2etest" = "true"
                            "test-run" = _now
                        }
                        publicAccess = True
                        nodeConfig = {
                            enabled = True
                        }
                        oidc = {
                            enabled = True
                        }
                    }
                }

                # 2. helm.aws CertManager - installs cert-manager with AWS Pod Identity
                {
                    apiVersion = "helm.aws.hops.ops.com.ai/v1alpha1"
                    kind = "CertManager"
                    metadata = {
                        name = "cert-manager"
                        namespace = _namespace
                    }
                    spec = {
                        clusterName = _test_name
                        # helmProviderConfigRef defaults to clusterName (uses ProviderConfig created by AutoEKSCluster)
                        # awsProviderConfigRef must be explicit since AutoEKSCluster doesn't create an AWS ProviderConfig
                        awsProviderConfigRef = {
                            name = "default"
                            namespace = _namespace
                        }
                        aws = {
                            region = _region
                        }
                    }
                }
            ]
        }
    }
]

items = _items

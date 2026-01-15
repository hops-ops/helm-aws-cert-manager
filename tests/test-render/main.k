import models.io.upbound.dev.meta.v1alpha1 as metav1alpha1
import models.k8s.apimachinery.pkg.apis.meta.v1 as metav1

# ==============================================================================
# Unit tests for helm.aws CertManager XRD
# ==============================================================================

_items = [
    # ==========================================================================
    # Test 1: Minimal input renders Helm CertManager and Pod Identity
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "minimal-renders-helm-and-pod-identity"
        spec = {
            compositionPath = "apis/certmanagers/composition.yaml"
            xrdPath = "apis/certmanagers/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.aws.hops.ops.com.ai/v1alpha1"
                kind = "CertManager"
                metadata.name = "cert-manager"
                spec = {
                    clusterName = "my-cluster"
                    aws = {
                        region = "us-east-1"
                    }
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                    kind = "CertManager"
                    metadata.name = "cert-manager"
                    spec.clusterName = "my-cluster"
                }
                {
                    apiVersion = "aws.hops.ops.com.ai/v1alpha1"
                    kind = "PodIdentity"
                    metadata.name = "cert-manager-pod-identity"
                    spec = {
                        clusterName = "my-cluster"
                        region = "us-east-1"
                        serviceAccount = {
                            name = "cert-manager"
                            namespace = "cert-manager"
                        }
                    }
                }
            ]
        }
    }

    # ==========================================================================
    # Test 2: Custom namespace propagates to both resources
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "custom-namespace-propagates"
        spec = {
            compositionPath = "apis/certmanagers/composition.yaml"
            xrdPath = "apis/certmanagers/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.aws.hops.ops.com.ai/v1alpha1"
                kind = "CertManager"
                metadata.name = "cert-manager"
                spec = {
                    clusterName = "prod-cluster"
                    namespace = "cert-manager-system"
                    aws = {
                        region = "us-west-2"
                        rolePrefix = "prod-"
                    }
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                    kind = "CertManager"
                    metadata.name = "cert-manager"
                    spec.namespace = "cert-manager-system"
                }
                {
                    apiVersion = "aws.hops.ops.com.ai/v1alpha1"
                    kind = "PodIdentity"
                    metadata.name = "cert-manager-pod-identity"
                    spec = {
                        rolePrefix = "prod-"
                        serviceAccount = {
                            namespace = "cert-manager-system"
                        }
                    }
                }
            ]
        }
    }
]

items = _items

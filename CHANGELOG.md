### What's changed in v0.1.0

* feat: initial helm-aws-cert-manager configuration (by @patrickleet)

  Installs cert-manager with AWS Pod Identity for Route53 DNS01 challenges.

  Composes:
  - helm.hops.ops.com.ai/CertManager (base Helm release)
  - aws.hops.ops.com.ai/PodIdentity (IAM role + Pod Identity)

  Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>

* feat(deps): update dependency aws-pod-identity to v0.4.1 (#1) (by @renovate[bot])

  Co-authored-by: renovate[bot] <29139614+renovate[bot]@users.noreply.github.com>

* chore(deps): update unbounded-tech/workflow-simple-release action to v2.1.1 (#2) (by @renovate[bot])

  Co-authored-by: renovate[bot] <29139614+renovate[bot]@users.noreply.github.com>

* chore(deps): update unbounded-tech/workflows-crossplane action to v0.10.0 (#4) (by @renovate[bot])

  Co-authored-by: renovate[bot] <29139614+renovate[bot]@users.noreply.github.com>

* feat: usages + refactor (by @patrickleet)

* chore: run on test network (by @patrickleet)

* feat: defaultCompositeDeletePolicy  Foreground (by @patrickleet)

* chore: fix e2e PC config (by @patrickleet)

* chore: fix e2e PC config (by @patrickleet)

* chore(deps): update unbounded-tech/workflows-crossplane action to v2 (#6) (by @renovate[bot])

  Co-authored-by: renovate[bot] <29139614+renovate[bot]@users.noreply.github.com>

* feat(deps): update dependency helm-cert-manager to v0.5.0 (#5) (by @renovate[bot])

  Co-authored-by: renovate[bot] <29139614+renovate[bot]@users.noreply.github.com>

* feat: helm-cert-manager v0.6.0 + fix aws provider name default (by @patrickleet)

* fix: timeout (by @patrickleet)

* feat(deps): update dependency aws-pod-identity to v0.5.0 (#7) (by @renovate[bot])

  Co-authored-by: renovate[bot] <29139614+renovate[bot]@users.noreply.github.com>

* fix: cluster config (by @patrickleet)

  Signed-off-by: Patrick Lee Scott <pat@patscott.io>

* chore(deps): update unbounded-tech/workflow-vnext-tag action to v1.21.0 (#8) (by @renovate[bot])

  Co-authored-by: renovate[bot] <29139614+renovate[bot]@users.noreply.github.com>

* feat(deps): update dependency helm-cert-manager to v0.6.1 (#9) (by @renovate[bot])

  Co-authored-by: renovate[bot] <29139614+renovate[bot]@users.noreply.github.com>

* feat: admin role arn (by @patrickleet)

  Signed-off-by: Patrick Lee Scott <pat@patscott.io>



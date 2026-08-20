# security/managed-identity

Creates one or more user-assigned managed identities and, optionally, federated
identity credentials for workload identity federation (Kubernetes, GitHub Actions
OIDC, etc). Role assignments for these identities are composed separately using the
`security/role-assignment` module.

## Usage

```hcl
module "identities" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/security/managed-identity?ref=v1.0.0"

  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location

  identities = {
    ci = { name = "gh-actions-ci" }
  }

  federated_credentials = {
    ci-main = {
      identity_key = "ci"
      issuer       = "https://token.actions.githubusercontent.com"
      subject      = "repo:my-org/my-repo:ref:refs/heads/main"
    }
  }

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

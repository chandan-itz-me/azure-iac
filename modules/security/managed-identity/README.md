# security/managed-identity

Creates one or more user-assigned managed identities and, optionally, federated
identity credentials for workload identity federation (Kubernetes, GitHub Actions
OIDC, etc). Role assignments for these identities are composed separately using the
`security/role-assignment` module.

## When To Use

Use this module when an identity must survive replacement of a workload, be shared by
multiple resources, or be used by an external workload such as GitHub Actions. Use a
system-assigned identity for a tightly coupled resource when its lifecycle can match
the workload.

## Composition Order

Create identities first, pass their `identity_ids` to supported workload modules, then
create role assignments using their `principal_ids`. The root composition accepts
identity references in the form `module-key.identity-key`.

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

## Security and Operations

- Use environment and workload names, such as `platform-prod-api`.
- Grant roles at the narrowest practical scope; avoid subscription-wide roles.
- Federated credential subjects must be exact. Prefer branch or environment
  restrictions over repository-wide wildcards.
- Use client IDs for token acquisition, principal IDs for Azure RBAC, and resource IDs
  when attaching a user-assigned identity to an Azure resource.
- Deleting an identity can break every attached workload and role assignment; review
  replacement plans carefully.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.90.0, < 4.0.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.117.1 |

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_federated_identity_credential.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_identities"></a> [identities](#input\_identities) | Map of user-assigned managed identities to create, keyed by a unique identity key. | <pre>map(object({<br/>    name = string<br/>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region the managed identities are deployed to. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the managed identities are created in. | `string` | n/a | yes |
| <a name="input_federated_credentials"></a> [federated\_credentials](#input\_federated\_credentials) | Map of federated identity credentials for workload identity federation (e.g. GitHub Actions OIDC), keyed by a unique credential name. | <pre>map(object({<br/>    identity_key = string<br/>    issuer       = string<br/>    subject      = string<br/>    audiences    = optional(list(string), ["api://AzureADTokenExchange"])<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_client_ids"></a> [client\_ids](#output\_client\_ids) | Map of identity keys to their client (application) IDs. |
| <a name="output_identity_ids"></a> [identity\_ids](#output\_identity\_ids) | Map of identity keys to their resource IDs. |
| <a name="output_principal_ids"></a> [principal\_ids](#output\_principal\_ids) | Map of identity keys to their principal (object) IDs. |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | Azure AD tenant ID shared by all identities created by this module. |
<!-- END_TF_DOCS -->

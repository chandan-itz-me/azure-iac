# security/role-assignment

Grants least-privilege role assignments from a map of principals to scopes, and
optionally defines custom role definitions that assignments can reference. Scopes
and resource groups/locations are not managed by this module since role assignments
and custom role definitions can target management groups, subscriptions, resource
groups or individual resources.

## Purpose

This module is the Azure equivalent of attaching AWS IAM policies to a workload role.
`principal_id` identifies the workload, `scope` sets the resource boundary, and
`role_definition_name` should be a built-in least-privilege role whenever possible.

## Safe Composition

Create the identity, create the target resource, then create this module. Use a
user-assigned identity's `principal_ids` or a workload module's
`identity_principal_id`. Keep the identity, target, and assignment in the same state
when possible so Terraform manages dependency ordering.

## Usage

```hcl
module "role_assignments" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/security/role-assignment?ref=v1.0.0"

  custom_role_definitions = {
    reader_plus = {
      name  = "Reader Plus"
      scope = data.azurerm_subscription.current.id
      permissions = {
        actions = ["Microsoft.Resources/subscriptions/resourceGroups/read"]
      }
      assignable_scopes = [data.azurerm_subscription.current.id]
    }
  }

  assignments = {
    ci-contributor = {
      scope                = azurerm_resource_group.platform.id
      role_definition_name = "Contributor"
      principal_id         = module.identities.principal_ids["ci"]
      principal_type       = "ServicePrincipal"
    }
    ci-reader-plus = {
      scope           = data.azurerm_subscription.current.id
      custom_role_key = "reader_plus"
      principal_id    = module.identities.principal_ids["ci"]
      principal_type  = "ServicePrincipal"
    }
  }
}
```

## Security Notes

- Prefer data-plane roles such as `Storage Blob Data Reader` over `Contributor`.
- Scope assignments to a resource, resource group, or specific child resource.
- Custom roles should contain only required `actions`, `data_actions`, and scopes.
- Role assignment deletion is an access change; review it like a resource deletion.

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
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_assignments"></a> [assignments](#input\_assignments) | Map of role assignments, keyed by a unique assignment key. Exactly one of role\_definition\_name, role\_definition\_id or custom\_role\_key must be set. | <pre>map(object({<br/>    scope                = string<br/>    role_definition_name = optional(string)<br/>    role_definition_id   = optional(string)<br/>    custom_role_key      = optional(string)<br/>    principal_id         = string<br/>    principal_type       = optional(string)<br/>    condition            = optional(string)<br/>    condition_version    = optional(string)<br/>    description          = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_custom_role_definitions"></a> [custom\_role\_definitions](#input\_custom\_role\_definitions) | Map of custom role definitions to create, keyed by a unique role key. Referenced from assignments via custom\_role\_key. | <pre>map(object({<br/>    name        = string<br/>    scope       = string<br/>    description = optional(string)<br/>    permissions = object({<br/>      actions          = optional(list(string), [])<br/>      not_actions      = optional(list(string), [])<br/>      data_actions     = optional(list(string), [])<br/>      not_data_actions = optional(list(string), [])<br/>    })<br/>    assignable_scopes = list(string)<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_assignment_ids"></a> [assignment\_ids](#output\_assignment\_ids) | Map of assignment keys to their role assignment IDs. |
| <a name="output_custom_role_definition_ids"></a> [custom\_role\_definition\_ids](#output\_custom\_role\_definition\_ids) | Map of custom role keys to their role definition resource IDs. |
<!-- END_TF_DOCS -->

# security/role-assignment

Grants least-privilege role assignments from a map of principals to scopes, and
optionally defines custom role definitions that assignments can reference. Scopes
and resource groups/locations are not managed by this module since role assignments
and custom role definitions can target management groups, subscriptions, resource
groups or individual resources.

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

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

# state-backend/storage-backend

Bootstraps the Azure resources needed for a Terraform `azurerm` remote
state backend: a resource group (optionally created, or an existing one
by name), a storage account with public network access disabled by
default, TLS 1.2 enforced and blob versioning/soft-delete enabled, and a
private container for state blobs. Optionally encrypts the account with
a customer-managed key from an existing Key Vault and grants Storage
Blob Data Contributor to a list of Terraform runner principals.

Because this module creates the very backend a Terraform configuration
would otherwise use, it must be bootstrapped once with local state before
any configuration can point at it:

1. Apply this module with a local backend (or no backend block at all).
2. Note the `backend_config` output.
3. Add a `backend "azurerm" {}` block to the consuming configuration and
   run `terraform init -migrate-state`, passing the values above via
   `-backend-config` or a partial configuration.

## Usage

```hcl
module "state_backend" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/state-backend/storage-backend?ref=v1.0.0"

  resource_group_name  = "platform-tfstate-rg"
  location             = "eastus2"
  storage_account_name = "platformtfstate001"

  allowed_ip_rules = ["203.0.113.10/32"]

  create_role_assignments = true
  runner_principal_ids    = [data.azuread_service_principal.ci.object_id]

  tags = {
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}
```

Resulting backend block a consumer configuration would paste, preferring
Azure AD authentication over storage account access keys:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "platform-tfstate-rg"
    storage_account_name = "platformtfstate001"
    container_name        = "tfstate"
    key                    = "platform.tfstate"
    use_azuread_auth      = true
  }
}
```

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
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account_customer_managed_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_customer_managed_key) | resource |
| [azurerm_storage_container.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_location"></a> [location](#input\_location) | Azure region the state backend resources are deployed to. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group to create, or the name of an existing resource group when create\_resource\_group is false. | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Globally unique name of the storage account hosting Terraform state (lowercase letters and numbers only, 3-24 characters). | `string` | n/a | yes |
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | Replication strategy for the storage account. Defaults to GRS for cross-region durability of state files. | `string` | `"GRS"` | no |
| <a name="input_allowed_ip_rules"></a> [allowed\_ip\_rules](#input\_allowed\_ip\_rules) | Public IP address ranges allowed to reach the storage account when public network access is restricted (e.g. CI runner egress IPs). | `list(string)` | `[]` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Name of the blob container that stores Terraform state files. | `string` | `"tfstate"` | no |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Whether to create the resource group. Set to false to use an existing resource group named by resource\_group\_name. | `bool` | `true` | no |
| <a name="input_create_role_assignments"></a> [create\_role\_assignments](#input\_create\_role\_assignments) | Whether to grant Storage Blob Data Contributor on the storage account to the principals in runner\_principal\_ids. | `bool` | `false` | no |
| <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key) | Customer-managed key configuration. Required when enable\_customer\_managed\_key is true. The storage account is granted a system-assigned identity to access the key. | <pre>object({<br/>    key_vault_id              = string<br/>    key_name                  = string<br/>    key_version               = optional(string, null)<br/>    user_assigned_identity_id = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_delete_retention_days"></a> [delete\_retention\_days](#input\_delete\_retention\_days) | Number of days deleted blobs are retained, enabling recovery of accidentally deleted or overwritten state files. | `number` | `30` | no |
| <a name="input_enable_customer_managed_key"></a> [enable\_customer\_managed\_key](#input\_enable\_customer\_managed\_key) | Whether the storage account is encrypted with a customer-managed key from an existing Key Vault, instead of Microsoft-managed keys. | `bool` | `false` | no |
| <a name="input_min_tls_version"></a> [min\_tls\_version](#input\_min\_tls\_version) | Minimum TLS version accepted by the storage account. | `string` | `"TLS1_2"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether public network access to the storage account is enabled. Disabled by default; CI runners will need an allowed\_ip\_rules entry or a private endpoint to reach the backend. | `bool` | `false` | no |
| <a name="input_runner_principal_ids"></a> [runner\_principal\_ids](#input\_runner\_principal\_ids) | Object IDs of the service principals or managed identities (e.g. Terraform CI runners) granted Storage Blob Data Contributor when create\_role\_assignments is true. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_backend_config"></a> [backend\_config](#output\_backend\_config) | Values for the azurerm backend block or a -backend-config file. The key is a placeholder; set it per state file (e.g. "<environment>.tfstate"). |
| <a name="output_container_name"></a> [container\_name](#output\_container\_name) | Name of the blob container storing Terraform state files. |
| <a name="output_primary_blob_endpoint"></a> [primary\_blob\_endpoint](#output\_primary\_blob\_endpoint) | Primary blob service endpoint of the storage account. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group hosting the state backend. |
| <a name="output_role_assignment_ids"></a> [role\_assignment\_ids](#output\_role\_assignment\_ids) | Map of principal ID to the ID of its Storage Blob Data Contributor role assignment. |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | ID of the storage account hosting Terraform state. |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | Name of the storage account hosting Terraform state. |
<!-- END_TF_DOCS -->

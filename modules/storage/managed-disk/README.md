# storage/managed-disk

Creates one or more Azure managed disks and, optionally, a disk encryption set backed
by a Key Vault key. Disks default to `Premium_LRS` with network access denied by
default; reference the module's disk encryption set output or bring your own
`disk_encryption_set_id` per disk.

## Usage

```hcl
module "managed_disk" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/storage/managed-disk?ref=v1.0.0"

  name                = "data-disks"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location

  disks = {
    data-01 = {
      disk_size_gb = 128
      zone         = "1"
    }
  }

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
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
| [azurerm_disk_encryption_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) | resource |
| [azurerm_managed_disk.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_location"></a> [location](#input\_location) | Azure region the managed disks are deployed to. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the managed disks are created in. | `string` | n/a | yes |
| <a name="input_disk_encryption_set"></a> [disk\_encryption\_set](#input\_disk\_encryption\_set) | Optional disk encryption set created by this module. When enabled, disks may reference its ID via disk\_encryption\_set\_id. | <pre>object({<br/>    enabled                    = bool<br/>    key_vault_key_id           = string<br/>    identity_type              = optional(string, "SystemAssigned")<br/>    user_assigned_identity_ids = optional(list(string), [])<br/>  })</pre> | <pre>{<br/>  "enabled": false,<br/>  "identity_type": "SystemAssigned",<br/>  "key_vault_key_id": null,<br/>  "user_assigned_identity_ids": []<br/>}</pre> | no |
| <a name="input_disks"></a> [disks](#input\_disks) | Map of managed disks to create, keyed by disk name. | <pre>map(object({<br/>    storage_account_type   = optional(string, "Premium_LRS")<br/>    disk_size_gb           = optional(number, null)<br/>    create_option          = optional(string, "Empty")<br/>    source_resource_id     = optional(string, null)<br/>    source_uri             = optional(string, null)<br/>    os_type                = optional(string, null)<br/>    hyper_v_generation     = optional(string, null)<br/>    disk_encryption_set_id = optional(string, null)<br/>    network_access_policy  = optional(string, "DenyAll")<br/>    disk_access_id         = optional(string, null)<br/>    zone                   = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name prefix applied to resources created by this module when a single logical name is required. | `string` | `"managed-disk"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_disk_encryption_set_id"></a> [disk\_encryption\_set\_id](#output\_disk\_encryption\_set\_id) | ID of the disk encryption set created by this module, if enabled. |
| <a name="output_disk_encryption_set_identity_principal_id"></a> [disk\_encryption\_set\_identity\_principal\_id](#output\_disk\_encryption\_set\_identity\_principal\_id) | Principal ID of the disk encryption set's managed identity, if enabled. |
| <a name="output_disk_ids"></a> [disk\_ids](#output\_disk\_ids) | Map of disk name to managed disk resource ID. |
<!-- END_TF_DOCS -->

# compute/virtual-machine

Creates a Linux or Windows virtual machine with its network interface, optional public IP,
optional additional data disks and extensions. Selects `azurerm_linux_virtual_machine` or
`azurerm_windows_virtual_machine` based on `os_type` so a single module can back both operating
system families.

## Usage

```hcl
module "vm" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/compute/virtual-machine?ref=v1.0.0"

  name                  = "app01"
  resource_group_name   = azurerm_resource_group.app.name
  location              = azurerm_resource_group.app.location
  os_type               = "linux"
  size                  = "Standard_D2s_v5"
  admin_username        = "azureuser"
  admin_ssh_public_key  = file("~/.ssh/id_rsa.pub")
  subnet_id             = module.subnet.subnet_id

  source_image_reference = {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
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
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.117.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.9.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_linux_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_managed_disk.data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_virtual_machine_data_disk_attachment.data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_extension.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Administrator username for the virtual machine. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region the virtual machine is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the virtual machine and prefix applied to associated resources. | `string` | n/a | yes |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | Operating system family of the virtual machine, linux or windows. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the virtual machine is created in. | `string` | n/a | yes |
| <a name="input_size"></a> [size](#input\_size) | Azure VM size (SKU), e.g. Standard\_D2s\_v5. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the subnet the virtual machine's network interface is attached to. | `string` | n/a | yes |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Administrator password. Required for windows VMs unless generate\_admin\_password is true. Ignored for linux VMs. | `string` | `null` | no |
| <a name="input_admin_ssh_public_key"></a> [admin\_ssh\_public\_key](#input\_admin\_ssh\_public\_key) | SSH public key for the admin user. Required for Linux VMs. | `string` | `null` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Availability zone the virtual machine is pinned to. Uses no zone pinning when null. | `string` | `null` | no |
| <a name="input_boot_diagnostics_enabled"></a> [boot\_diagnostics\_enabled](#input\_boot\_diagnostics\_enabled) | Whether boot diagnostics are enabled for the virtual machine. | `bool` | `true` | no |
| <a name="input_boot_diagnostics_storage_account_uri"></a> [boot\_diagnostics\_storage\_account\_uri](#input\_boot\_diagnostics\_storage\_account\_uri) | Blob endpoint of the storage account used for boot diagnostics. Uses a Microsoft-managed storage account when null. | `string` | `null` | no |
| <a name="input_custom_data"></a> [custom\_data](#input\_custom\_data) | Base64-encoded custom data (cloud-init or PowerShell) passed to the virtual machine at provisioning time. | `string` | `null` | no |
| <a name="input_data_disks"></a> [data\_disks](#input\_data\_disks) | Map of additional managed data disks to create and attach, keyed by a unique disk name. | <pre>map(object({<br/>    storage_account_type = optional(string, "Premium_LRS")<br/>    disk_size_gb         = number<br/>    lun                  = number<br/>    caching              = optional(string, "ReadWrite")<br/>  }))</pre> | `{}` | no |
| <a name="input_extensions"></a> [extensions](#input\_extensions) | Map of VM extensions to install, keyed by a unique extension name. | <pre>map(object({<br/>    publisher                  = string<br/>    type                       = string<br/>    type_handler_version       = string<br/>    auto_upgrade_minor_version = optional(bool, true)<br/>    settings                   = optional(string)<br/>    protected_settings         = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_generate_admin_password"></a> [generate\_admin\_password](#input\_generate\_admin\_password) | Whether to generate a random administrator password instead of using admin\_password. | `bool` | `false` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | List of user assigned identity IDs. Required when identity\_type includes UserAssigned. | `list(string)` | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Type of managed identity assigned to the virtual machine. | `string` | `"SystemAssigned"` | no |
| <a name="input_os_disk"></a> [os\_disk](#input\_os\_disk) | OS disk configuration for the virtual machine. | <pre>object({<br/>    caching                = string<br/>    storage_account_type   = optional(string, "Premium_LRS")<br/>    disk_size_gb           = optional(number)<br/>    disk_encryption_set_id = optional(string)<br/>  })</pre> | <pre>{<br/>  "caching": "ReadWrite"<br/>}</pre> | no |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | Static private IP address to assign. Uses dynamic allocation when null. | `string` | `null` | no |
| <a name="input_public_ip_allocation_method"></a> [public\_ip\_allocation\_method](#input\_public\_ip\_allocation\_method) | Allocation method for the public IP address, Static or Dynamic. Only used when public\_ip\_enabled is true. | `string` | `"Static"` | no |
| <a name="input_public_ip_enabled"></a> [public\_ip\_enabled](#input\_public\_ip\_enabled) | Whether a public IP address is created and associated with the virtual machine. | `bool` | `false` | no |
| <a name="input_public_ip_sku"></a> [public\_ip\_sku](#input\_public\_ip\_sku) | SKU of the public IP address. Only used when public\_ip\_enabled is true. | `string` | `"Standard"` | no |
| <a name="input_source_image_id"></a> [source\_image\_id](#input\_source\_image\_id) | ID of a custom image or shared image gallery version. Mutually exclusive with source\_image\_reference. | `string` | `null` | no |
| <a name="input_source_image_reference"></a> [source\_image\_reference](#input\_source\_image\_reference) | Marketplace image reference (publisher, offer, sku, version). Mutually exclusive with source\_image\_id. | <pre>object({<br/>    publisher = string<br/>    offer     = string<br/>    sku       = string<br/>    version   = string<br/>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_data_disk_ids"></a> [data\_disk\_ids](#output\_data\_disk\_ids) | Map of additional data disk IDs, keyed by disk name. |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | Principal ID of the virtual machine's system-assigned managed identity, if enabled. |
| <a name="output_network_interface_id"></a> [network\_interface\_id](#output\_network\_interface\_id) | ID of the virtual machine's network interface. |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | Private IP address of the virtual machine's network interface. |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | Public IP address associated with the virtual machine, if any. |
| <a name="output_vm_id"></a> [vm\_id](#output\_vm\_id) | ID of the virtual machine. |
<!-- END_TF_DOCS -->

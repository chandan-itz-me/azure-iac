# compute/vmss

Creates a Linux or Windows virtual machine scale set in Uniform or Flexible orchestration mode,
with an optional CPU-based autoscale setting. Selects `azurerm_linux_virtual_machine_scale_set`
or `azurerm_windows_virtual_machine_scale_set` based on `os_type` so a single module can back
both operating system families.

## Usage

```hcl
module "vmss" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/compute/vmss?ref=v1.0.0"

  name                 = "app-vmss"
  resource_group_name  = azurerm_resource_group.app.name
  location             = azurerm_resource_group.app.location
  os_type              = "linux"
  sku                  = "Standard_D2s_v5"
  instances            = 3
  admin_username       = "azureuser"
  admin_ssh_public_key = file("~/.ssh/id_rsa.pub")
  subnet_id            = module.subnet.subnet_id

  source_image_reference = {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  enable_autoscale = true

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
| [azurerm_linux_virtual_machine_scale_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_monitor_autoscale_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_autoscale_setting) | resource |
| [azurerm_windows_virtual_machine_scale_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine_scale_set) | resource |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Administrator username for scale set instances. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region the scale set is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the virtual machine scale set. | `string` | n/a | yes |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | Operating system family of the scale set instances, linux or windows. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the scale set is created in. | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | Azure VM size (SKU) used for scale set instances, e.g. Standard\_D2s\_v5. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the subnet the scale set's network interfaces are attached to. | `string` | n/a | yes |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Administrator password. Required for windows scale sets unless generate\_admin\_password is true. Ignored for linux scale sets. | `string` | `null` | no |
| <a name="input_admin_ssh_public_key"></a> [admin\_ssh\_public\_key](#input\_admin\_ssh\_public\_key) | SSH public key for the admin user. Required for linux scale sets when generate\_admin\_password is false. | `string` | `null` | no |
| <a name="input_application_gateway_backend_address_pool_ids"></a> [application\_gateway\_backend\_address\_pool\_ids](#input\_application\_gateway\_backend\_address\_pool\_ids) | List of application gateway backend address pool IDs to associate with the scale set. | `list(string)` | `[]` | no |
| <a name="input_autoscale_default_instances"></a> [autoscale\_default\_instances](#input\_autoscale\_default\_instances) | Default instance count for the autoscale setting. Only used when enable\_autoscale is true. | `number` | `2` | no |
| <a name="input_autoscale_max_instances"></a> [autoscale\_max\_instances](#input\_autoscale\_max\_instances) | Maximum instance count for the autoscale setting. Only used when enable\_autoscale is true. | `number` | `5` | no |
| <a name="input_autoscale_min_instances"></a> [autoscale\_min\_instances](#input\_autoscale\_min\_instances) | Minimum instance count for the autoscale setting. Only used when enable\_autoscale is true. | `number` | `1` | no |
| <a name="input_enable_autoscale"></a> [enable\_autoscale](#input\_enable\_autoscale) | Whether an autoscale setting is created for the scale set. | `bool` | `false` | no |
| <a name="input_generate_admin_password"></a> [generate\_admin\_password](#input\_generate\_admin\_password) | Whether to generate a random administrator password instead of using admin\_password. | `bool` | `false` | no |
| <a name="input_health_probe_id"></a> [health\_probe\_id](#input\_health\_probe\_id) | ID of a load balancer health probe used to monitor instance health during rolling upgrades. | `string` | `null` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | List of user assigned identity IDs. Required when identity\_type includes UserAssigned. | `list(string)` | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Type of managed identity assigned to scale set instances. | `string` | `"SystemAssigned"` | no |
| <a name="input_instances"></a> [instances](#input\_instances) | Base number of instances running in the scale set. | `number` | `2` | no |
| <a name="input_lb_backend_address_pool_ids"></a> [lb\_backend\_address\_pool\_ids](#input\_lb\_backend\_address\_pool\_ids) | List of load balancer backend address pool IDs to associate with the scale set. | `list(string)` | `[]` | no |
| <a name="input_os_disk"></a> [os\_disk](#input\_os\_disk) | OS disk configuration for scale set instances. | <pre>object({<br/>    caching                = string<br/>    storage_account_type   = optional(string, "Premium_LRS")<br/>    disk_size_gb           = optional(number)<br/>    disk_encryption_set_id = optional(string)<br/>  })</pre> | <pre>{<br/>  "caching": "ReadWrite"<br/>}</pre> | no |
| <a name="input_overprovision"></a> [overprovision](#input\_overprovision) | Whether the scale set overprovisions instances to improve deployment success rate. Not supported in Flexible orchestration mode. | `bool` | `true` | no |
| <a name="input_rolling_upgrade_policy"></a> [rolling\_upgrade\_policy](#input\_rolling\_upgrade\_policy) | Rolling upgrade policy. Only used when upgrade\_mode is "Rolling". | <pre>object({<br/>    max_batch_instance_percent              = number<br/>    max_unhealthy_instance_percent          = number<br/>    max_unhealthy_upgraded_instance_percent = number<br/>    pause_time_between_batches              = string<br/>  })</pre> | `null` | no |
| <a name="input_single_placement_group"></a> [single\_placement\_group](#input\_single\_placement\_group) | Whether the scale set is limited to a single placement group of up to 100 instances. | `bool` | `true` | no |
| <a name="input_source_image_id"></a> [source\_image\_id](#input\_source\_image\_id) | ID of a custom image or shared image gallery version. Mutually exclusive with source\_image\_reference. | `string` | `null` | no |
| <a name="input_source_image_reference"></a> [source\_image\_reference](#input\_source\_image\_reference) | Marketplace image reference (publisher, offer, sku, version). Mutually exclusive with source\_image\_id. | <pre>object({<br/>    publisher = string<br/>    offer     = string<br/>    sku       = string<br/>    version   = string<br/>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |
| <a name="input_upgrade_mode"></a> [upgrade\_mode](#input\_upgrade\_mode) | Upgrade mode for the scale set, Manual, Automatic or Rolling. | `string` | `"Manual"` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | List of availability zones the scale set is spread across. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | Principal ID of the scale set's system-assigned managed identity, if enabled. |
| <a name="output_instances"></a> [instances](#output\_instances) | Base number of instances configured on the scale set. |
| <a name="output_vmss_id"></a> [vmss\_id](#output\_vmss\_id) | ID of the virtual machine scale set. |
<!-- END_TF_DOCS -->

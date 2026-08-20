# networking/network-security-group

Creates a network security group and a map of explicit security rules. There is no
default allow-all rule: every inbound or outbound rule must be declared by the
caller. Optionally associates the group with existing subnets and/or network
interfaces.

## Usage

```hcl
module "nsg_app" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/networking/network-security-group?ref=v1.0.0"

  name                = "app-nsg"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location

  security_rules = {
    allow-https-inbound = {
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    }

    deny-all-inbound = {
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  subnet_ids = [module.subnets.subnet_ids["app"]]

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
| [azurerm_network_interface_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_location"></a> [location](#input\_location) | Azure region the network security group is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the network security group and prefix applied to associated resources. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the network security group is created in. | `string` | n/a | yes |
| <a name="input_network_interface_ids"></a> [network\_interface\_ids](#input\_network\_interface\_ids) | IDs of existing network interfaces to associate this network security group with. | `list(string)` | `[]` | no |
| <a name="input_security_rules"></a> [security\_rules](#input\_security\_rules) | Map of security rules to create on the network security group, keyed by rule name. No inbound access is allowed by default; every rule must be explicit. | <pre>map(object({<br/>    priority                                   = number<br/>    direction                                  = string<br/>    access                                     = string<br/>    protocol                                   = string<br/>    description                                = optional(string, null)<br/>    source_port_range                          = optional(string, null)<br/>    source_port_ranges                         = optional(list(string), null)<br/>    destination_port_range                     = optional(string, null)<br/>    destination_port_ranges                    = optional(list(string), null)<br/>    source_address_prefix                      = optional(string, null)<br/>    source_address_prefixes                    = optional(list(string), null)<br/>    destination_address_prefix                 = optional(string, null)<br/>    destination_address_prefixes               = optional(list(string), null)<br/>    source_application_security_group_ids      = optional(list(string), null)<br/>    destination_application_security_group_ids = optional(list(string), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | IDs of existing subnets to associate this network security group with. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_nsg_id"></a> [nsg\_id](#output\_nsg\_id) | ID of the network security group. |
| <a name="output_nsg_name"></a> [nsg\_name](#output\_nsg\_name) | Name of the network security group. |
| <a name="output_rule_ids"></a> [rule\_ids](#output\_rule\_ids) | Map of security rule name to its resource ID. |
<!-- END_TF_DOCS -->

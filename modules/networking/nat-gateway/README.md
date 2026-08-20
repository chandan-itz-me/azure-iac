# networking/nat-gateway

Creates a NAT gateway with a configurable idle timeout and SKU. Public outbound
connectivity can be provided either by public IP addresses created by this module,
existing public IP addresses, or an existing public IP prefix. Associates the NAT
gateway with a map of subnets.

## Usage

```hcl
module "nat_gateway" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/networking/nat-gateway?ref=v1.0.0"

  name                    = "platform-natgw"
  resource_group_name     = azurerm_resource_group.platform.name
  location                = azurerm_resource_group.platform.location
  idle_timeout_in_minutes = 10

  public_ip_names = ["platform-natgw-pip"]

  subnet_ids = {
    app  = module.subnets.subnet_ids["app"]
    data = module.subnets.subnet_ids["data"]
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
| [azurerm_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.created](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_nat_gateway_public_ip_association.existing](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_nat_gateway_public_ip_prefix_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_prefix_association) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet_nat_gateway_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_location"></a> [location](#input\_location) | Azure region the NAT gateway is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the NAT gateway and prefix applied to associated resources. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the NAT gateway is created in. | `string` | n/a | yes |
| <a name="input_existing_public_ip_ids"></a> [existing\_public\_ip\_ids](#input\_existing\_public\_ip\_ids) | IDs of existing public IP addresses to associate with the NAT gateway instead of creating new ones. | `set(string)` | `[]` | no |
| <a name="input_idle_timeout_in_minutes"></a> [idle\_timeout\_in\_minutes](#input\_idle\_timeout\_in\_minutes) | Idle timeout in minutes for the NAT gateway, between 4 and 120. | `number` | `4` | no |
| <a name="input_public_ip_names"></a> [public\_ip\_names](#input\_public\_ip\_names) | Names of new public IP addresses to create and associate with the NAT gateway. | `set(string)` | `[]` | no |
| <a name="input_public_ip_prefix_id"></a> [public\_ip\_prefix\_id](#input\_public\_ip\_prefix\_id) | ID of an existing public IP prefix to associate with the NAT gateway. | `string` | `null` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | SKU of the NAT gateway. | `string` | `"Standard"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Map of subnets to associate with the NAT gateway, keyed by a logical name. | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | Availability zones the NAT gateway and any public IPs created by this module are pinned to. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | ID of the NAT gateway. |
| <a name="output_public_ip_addresses"></a> [public\_ip\_addresses](#output\_public\_ip\_addresses) | Map of public IP name to its allocated IP address, for public IPs created by this module. |
| <a name="output_public_ip_ids"></a> [public\_ip\_ids](#output\_public\_ip\_ids) | Map of public IP name to its resource ID, for public IPs created by this module. |
<!-- END_TF_DOCS -->

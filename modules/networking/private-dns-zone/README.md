# networking/private-dns-zone

Creates a private DNS zone with a map of records of any supported type (A, AAAA,
CNAME, MX, PTR, SRV, TXT) and a map of virtual network links used to make the zone
resolvable from one or more virtual networks.

## Usage

```hcl
module "private_dns" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/networking/private-dns-zone?ref=v1.0.0"

  name                = "internal.contoso.com"
  resource_group_name = azurerm_resource_group.platform.name

  records = {
    app = {
      type   = "A"
      ttl    = 300
      values = ["10.0.1.10"]
    }

    api = {
      type   = "CNAME"
      ttl    = 300
      values = ["app.internal.contoso.com"]
    }
  }

  virtual_network_links = {
    platform = {
      virtual_network_id   = module.vnet.vnet_id
      registration_enabled = true
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
| [azurerm_private_dns_a_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_aaaa_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_aaaa_record) | resource |
| [azurerm_private_dns_cname_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_cname_record) | resource |
| [azurerm_private_dns_mx_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_mx_record) | resource |
| [azurerm_private_dns_ptr_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_ptr_record) | resource |
| [azurerm_private_dns_srv_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_srv_record) | resource |
| [azurerm_private_dns_txt_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_txt_record) | resource |
| [azurerm_private_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_name"></a> [name](#input\_name) | Name of the private DNS zone, e.g. internal.contoso.com. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the private DNS zone is created in. | `string` | n/a | yes |
| <a name="input_records"></a> [records](#input\_records) | Map of DNS records to create in the zone, keyed by record name. | <pre>map(object({<br/>    type   = string<br/>    ttl    = number<br/>    values = optional(list(string), [])<br/>    mx_records = optional(list(object({<br/>      preference = number<br/>      exchange   = string<br/>    })), [])<br/>    srv_records = optional(list(object({<br/>      priority = number<br/>      weight   = number<br/>      port     = number<br/>      target   = string<br/>    })), [])<br/>    txt_records = optional(list(object({<br/>      value = string<br/>    })), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |
| <a name="input_virtual_network_links"></a> [virtual\_network\_links](#input\_virtual\_network\_links) | Map of virtual network links to create for the zone, keyed by a logical name. | <pre>map(object({<br/>    virtual_network_id   = string<br/>    registration_enabled = optional(bool, false)<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_record_ids"></a> [record\_ids](#output\_record\_ids) | Map of record name to its resource ID, across all record types. |
| <a name="output_vnet_link_ids"></a> [vnet\_link\_ids](#output\_vnet\_link\_ids) | Map of virtual network link name to its resource ID. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | ID of the private DNS zone. |
| <a name="output_zone_name"></a> [zone\_name](#output\_zone\_name) | Name of the private DNS zone. |
<!-- END_TF_DOCS -->

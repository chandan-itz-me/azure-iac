# networking/vnet-gateway

Creates a Virtual Network Gateway (VPN or ExpressRoute) with its own public IP,
providing the hybrid connectivity edge that AWS's internet/NAT gateways cover on
that platform. Supports point-to-site VPN client configuration and, when
`create_site_to_site` is enabled, a map of on-premises local network gateways and
their site-to-site connections.

## Usage

```hcl
module "vpn_gateway" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/networking/vnet-gateway?ref=v1.0.0"

  name                = "platform-vpngw"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  subnet_id           = module.subnets.subnet_ids["GatewaySubnet"]

  sku = "VpnGw1"

  create_site_to_site = true

  local_network_gateways = {
    onprem = {
      gateway_address = "203.0.113.10"
      address_space   = ["192.168.0.0/16"]
    }
  }

  connections = {
    onprem = {
      local_network_gateway_key = "onprem"
      shared_key                = var.vpn_shared_key
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
| [azurerm_local_network_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/local_network_gateway) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_virtual_network_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway) | resource |
| [azurerm_virtual_network_gateway_connection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_location"></a> [location](#input\_location) | Azure region the virtual network gateway is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the virtual network gateway and prefix applied to associated resources. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the virtual network gateway is created in. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the GatewaySubnet the gateway's IP configuration is attached to. | `string` | n/a | yes |
| <a name="input_active_active"></a> [active\_active](#input\_active\_active) | Whether the gateway is deployed in an active-active configuration. | `bool` | `false` | no |
| <a name="input_connections"></a> [connections](#input\_connections) | Map of site-to-site VPN connections to create, keyed by a logical name. Only used when create\_site\_to\_site is true. | <pre>map(object({<br/>    local_network_gateway_key = string<br/>    shared_key                = string<br/>    connection_protocol       = optional(string, null)<br/>    enable_bgp                = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_create_site_to_site"></a> [create\_site\_to\_site](#input\_create\_site\_to\_site) | Whether to create local network gateways and connections for site-to-site VPNs. | `bool` | `false` | no |
| <a name="input_enable_bgp"></a> [enable\_bgp](#input\_enable\_bgp) | Whether BGP is enabled on the gateway. | `bool` | `false` | no |
| <a name="input_generation"></a> [generation](#input\_generation) | Generation of the virtual network gateway. | `string` | `"Generation1"` | no |
| <a name="input_local_network_gateways"></a> [local\_network\_gateways](#input\_local\_network\_gateways) | Map of on-premises local network gateways to create, keyed by a logical name. Only used when create\_site\_to\_site is true. | <pre>map(object({<br/>    gateway_address = optional(string, null)<br/>    gateway_fqdn    = optional(string, null)<br/>    address_space   = list(string)<br/>    bgp_settings = optional(object({<br/>      asn                 = number<br/>      bgp_peering_address = string<br/>    }), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_public_ip_sku"></a> [public\_ip\_sku](#input\_public\_ip\_sku) | SKU of the public IP address created for the gateway's IP configuration. | `string` | `"Standard"` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | SKU of the virtual network gateway. | `string` | `"VpnGw1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of virtual network gateway. | `string` | `"Vpn"` | no |
| <a name="input_vpn_client_configuration"></a> [vpn\_client\_configuration](#input\_vpn\_client\_configuration) | Point-to-site VPN client configuration. Leave null to disable point-to-site. | <pre>object({<br/>    address_space        = list(string)<br/>    vpn_client_protocols = optional(list(string), null)<br/>    aad_tenant           = optional(string, null)<br/>    aad_audience         = optional(string, null)<br/>    aad_issuer           = optional(string, null)<br/>    root_certificates = optional(list(object({<br/>      name             = string<br/>      public_cert_data = string<br/>    })), [])<br/>    revoked_certificates = optional(list(object({<br/>      name       = string<br/>      thumbprint = string<br/>    })), [])<br/>  })</pre> | `null` | no |
| <a name="input_vpn_type"></a> [vpn\_type](#input\_vpn\_type) | Routing type of the VPN gateway. | `string` | `"RouteBased"` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | Availability zones the gateway's public IP is pinned to. Only supported with zone-redundant SKUs. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_connection_ids"></a> [connection\_ids](#output\_connection\_ids) | Map of connection name to its resource ID, for site-to-site connections created by this module. |
| <a name="output_gateway_id"></a> [gateway\_id](#output\_gateway\_id) | ID of the virtual network gateway. |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | Public IP address of the virtual network gateway. |
<!-- END_TF_DOCS -->

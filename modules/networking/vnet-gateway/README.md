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
<!-- END_TF_DOCS -->

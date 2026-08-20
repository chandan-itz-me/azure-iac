# networking/vnet

Creates a virtual network with optional custom DNS servers, BGP community and DDoS
protection plan association. Subnets, route tables and NAT gateways are deliberately
kept in separate modules so they can be composed per environment.

## Usage

```hcl
module "vnet" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/networking/vnet?ref=v1.0.0"

  name                = "platform-vnet"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  address_space       = ["10.0.0.0/16"]

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

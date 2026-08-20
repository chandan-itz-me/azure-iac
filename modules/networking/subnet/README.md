# networking/subnet

Creates one or more subnets within an existing virtual network from a map of subnet
definitions. Each subnet can optionally declare service endpoints, a service
delegation, and an association to an existing network security group and/or route
table.

## Usage

```hcl
module "subnets" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/networking/subnet?ref=v1.0.0"

  resource_group_name  = azurerm_resource_group.platform.name
  virtual_network_name = module.vnet.vnet_name

  subnets = {
    app = {
      address_prefixes           = ["10.0.1.0/24"]
      network_security_group_id  = module.nsg_app.nsg_id
      service_endpoints          = ["Microsoft.Storage"]
    }

    data = {
      address_prefixes = ["10.0.2.0/24"]
      route_table_id    = azurerm_route_table.private.id
    }

    web = {
      address_prefixes = ["10.0.3.0/24"]

      delegation = {
        name = "webapp-delegation"
        service_delegation = {
          name    = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      }
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

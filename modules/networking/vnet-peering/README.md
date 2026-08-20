# networking/vnet-peering

Creates a peering from a local virtual network to a remote virtual network, and
optionally the reverse peering back from the remote virtual network. `virtual_network_id`
must be supplied even though the local peering resource only needs the local
virtual network name, because it becomes the `remote_virtual_network_id` of the
reverse peering.

## Usage

```hcl
module "hub_to_spoke" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/networking/vnet-peering?ref=v1.0.0"

  name                  = "hub-to-spoke"
  resource_group_name   = azurerm_resource_group.hub.name
  virtual_network_name  = module.hub_vnet.vnet_name
  virtual_network_id    = module.hub_vnet.vnet_id

  remote_virtual_network_id = module.spoke_vnet.vnet_id

  allow_gateway_transit = true

  create_reverse_peering     = true
  peer_resource_group_name   = azurerm_resource_group.spoke.name
  peer_virtual_network_name  = module.spoke_vnet.vnet_name
  reverse_use_remote_gateways = true
}
```

### Cross-subscription peering

`create_reverse_peering` only works when the remote virtual network is reachable
through this module's default `azurerm` provider configuration (same subscription,
or a subscription the default provider is authorized against). This module
deliberately does not declare `configuration_aliases` or a `provider` block, so it
stays a plain single-provider module. For peerings across subscriptions, set
`create_reverse_peering = false` here and instantiate this module a second time
against the remote subscription, passing an aliased provider from the root module:

```hcl
provider "azurerm" {
  alias           = "peer"
  subscription_id = "<remote-subscription-id>"
  features {}
}

module "spoke_to_hub" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/networking/vnet-peering?ref=v1.0.0"

  providers = {
    azurerm = azurerm.peer
  }

  name                       = "spoke-to-hub"
  resource_group_name        = azurerm_resource_group.spoke.name
  virtual_network_name       = module.spoke_vnet.vnet_name
  virtual_network_id         = module.spoke_vnet.vnet_id
  remote_virtual_network_id  = module.hub_vnet.vnet_id
  use_remote_gateways        = true
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

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
<!-- END_TF_DOCS -->

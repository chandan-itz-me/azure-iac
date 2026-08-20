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
<!-- END_TF_DOCS -->

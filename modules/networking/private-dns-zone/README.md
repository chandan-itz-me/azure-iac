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
<!-- END_TF_DOCS -->

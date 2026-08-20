# networking-edge/api-management

Creates an Azure API Management instance with legacy TLS/SSL protocols disabled by
default, optional virtual network integration, a managed identity, and maps of APIs,
products, named values and backends. Product-to-API associations and OpenAPI/WSDL
imports are driven entirely through input maps.

## Usage

```hcl
module "apim" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/networking-edge/api-management?ref=v1.0.0"

  name                = "platform-apim"
  resource_group_name = azurerm_resource_group.edge.name
  location            = azurerm_resource_group.edge.location
  publisher_name      = "Platform Team"
  publisher_email     = "platform@example.com"
  sku_name            = "Standard_1"

  apis = {
    orders = {
      display_name = "Orders API"
      path         = "orders"
      service_url  = "https://orders.internal.example.com"
    }
  }

  products = {
    partner = {
      display_name = "Partner"
      api_keys     = ["orders"]
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

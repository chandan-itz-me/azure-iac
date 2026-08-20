# observability/log-analytics-workspace

Creates a Log Analytics workspace with configurable retention and daily
ingestion cap, optional linked solutions (e.g. Security, ContainerInsights)
and an optional automation account linked service. Public ingestion and
query are enabled by default for compatibility; tighten both to false and
front the workspace with a private link scope in stricter environments.

## Usage

```hcl
module "log_analytics" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/observability/log-analytics-workspace?ref=v1.0.0"

  name                = "platform-law"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  retention_in_days   = 90

  solutions = {
    container-insights = {
      solution_name = "ContainerInsights"
      publisher     = "Microsoft"
      product       = "OMSGallery/ContainerInsights"
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

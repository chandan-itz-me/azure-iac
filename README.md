# Azure Terraform Module Library

A versioned, composable library of Azure Terraform modules. Modules are intentionally
small enough to compose into an environment repository while keeping security defaults
and provider requirements consistent. This mirrors the structure of the AWS module
library (`aws-iac`) using Azure-native services.

## Repository Layout

```text
modules/
  networking/       VNet, subnets, NSGs, NAT gateway, private DNS, peering, private
                     endpoints, VPN/ExpressRoute gateway
  compute/          VM, VMSS, AKS, Container Apps, Function App, App Service
  storage/          Storage account, managed disk
  database/         Cosmos DB, Azure SQL Database, Redis Cache
  networking-edge/  Application Gateway, Front Door, API Management
  security/         Managed identity, role assignment, Key Vault (+ certs, secrets)
  messaging/        Service Bus, Event Grid, Event Hub
  observability/    Log Analytics, diagnostic settings, monitor alerts
  state-backend/    Storage account remote-state bootstrap
```

Every module contains `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, and a
terraform-docs-compatible `README.md`. Environment values such as subscription IDs,
tenant IDs, regions, and address spaces belong in the consuming repository.

## Consuming A Module

Pin a release tag rather than a branch or commit while deploying:

```hcl
module "vnet" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/networking/vnet?ref=v1.0.0"

  name                = "platform-vnet"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  address_space       = [var.vnet_cidr]

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
```

Use a release workflow such as `v1.0.0`, `v1.1.0`, and `v2.0.0`. Patch releases should
remain backward compatible; breaking input or output changes require a major release.

## Provider Version

Modules pin `azurerm` to `>= 3.90.0, < 4.0.0`. This intentionally targets the 3.x
resource schema (for example `azurerm_storage_container.storage_account_name`,
`azurerm_private_dns_a_record.zone_name`/`resource_group_name`, and
`azurerm_virtual_network_gateway.enable_bgp`). Azure renamed several arguments in the
4.x and 5.x provider lines; upgrading the constraint requires re-validating every
module against the new schema before widening it.

No module declares a `provider` or `features {}` block. Configure the `azurerm`
provider, including `features {}`, in the root module that consumes this library.

## Quality Gates

Local prerequisites are Terraform, TFLint, Trivy, terraform-docs, and pre-commit.
The repository workflow runs formatting, per-module initialization and validation,
TFLint, and Trivy on pull requests. Run the same checks locally with:

```text
terraform fmt -check -recursive
pre-commit run --all-files
```

## Root Composition

As with `aws-iac`, the intent is for a consuming repository's root `*.tf` files to be
ready-to-use callers for these modules, with optional service maps defaulting to `{}`
so a resource is created only when configured. No root composition exists in this
repository yet; add one following the same pattern as `aws-iac` when needed.

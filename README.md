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

The repository root is a complete environment composition. It creates the shared
resource group, VNet, subnets, application storage, Key Vault, Function App, managed
identity, and Log Analytics workspace. Optional service maps in `variables.tf` enable
additional compute, database, messaging, edge, security, observability, storage, and
state-backend modules without changing the root files.

Replace every `REPLACE_WITH_*` placeholder in the backend and environment files before
running `terraform init`. Keep credentials and secret values outside Git.

## Managed Identity Pattern

Azure does not use AWS-style trust policies. The equivalent composition is:

1. Create reusable user-assigned identities through `managed_identities`.
2. Attach them to supported workloads with `identity_type = "UserAssigned"` and
  `managed_identity_keys = ["identity-module.identity-key"]`.
3. Grant least-privilege access through `role_assignments`, using
  `principal_identity_key = "category.logical-name"` for automatically created
  workload identities.
4. Consume `workload_identity_principal_ids` or
  `managed_identity_principal_ids` when another module or external system
  needs the identity object ID.

System-assigned identities remain the default for optional supported workloads. The
core Function App is explicitly attached to its dedicated user-assigned identity so
role assignments remain stable if the app is replaced.

## Quality Gates

Local prerequisites are Terraform, TFLint, Trivy, terraform-docs, and pre-commit.
The workflows run formatting, per-module initialization and validation, TFLint, and
Trivy. The module-docs workflow injects generated variables, outputs, resources, and
requirements into every module README after module changes reach `main`.

```text
terraform fmt -check -recursive
terraform validate -no-color
tflint --recursive --config "$(pwd)/.tflint.hcl"
trivy config modules --severity HIGH,CRITICAL
pre-commit run --all-files
```

An authenticated plan, RBAC review, quota check, and remote-state bootstrap are still
required before a production apply.

# Azure Module Catalog

This directory contains independently composable AzureRM modules. Each module owns
one Azure capability and exposes typed inputs and outputs; provider authentication and
the `azurerm` `features {}` block belong in the consuming root module.

## Module Categories

| Category | Scope | Composition guidance |
| --- | --- | --- |
| Networking | VNet, subnets, NAT, NSGs, private DNS, endpoints, peering, gateways | Build the network foundation first |
| Compute | VM, VMSS, AKS, Container Apps, App Service, Function App | Attach subnets and identities |
| Storage | Storage account, managed disk | Create before dependent workloads |
| Database | Cosmos DB, Azure SQL, Redis | Apply private access and encryption settings |
| Messaging | Service Bus, Event Grid, Event Hubs | Attach workload identities and roles |
| Edge | Application Gateway, Front Door, API Management | Compose certificates and backend targets |
| Security | Key Vault, certificates, secrets, identities, RBAC | Create identities before permissions |
| Observability | Log Analytics, diagnostics, alerts | Wire after target IDs exist |
| State backend | Remote-state storage bootstrap | Run separately with local state first |

## Standard Contract

Each module contains `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, and a
README. Inputs are validated where Azure has finite choices. Outputs expose resource
IDs, names, endpoints, and workload identity principal IDs where supported. Keys,
connection strings, and secret values are marked `sensitive`.

## Identity and Permissions

Use `security/managed-identity` for stable user-assigned identities and
`security/role-assignment` for least-privilege RBAC. Workload modules accept either
`identity_type` and `identity_ids` or an equivalent `identity` object. Azure provides
implicit service trust; no AWS-style assume-role document is required.

## Documentation and Validation

The `BEGIN_TF_DOCS` sections are maintained by the `module-docs` GitHub Actions
workflow. Initialize each module with `terraform init -backend=false`, then run
`terraform validate`. The root composition additionally requires environment values,
Azure credentials, and a configured backend for a real plan.
<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
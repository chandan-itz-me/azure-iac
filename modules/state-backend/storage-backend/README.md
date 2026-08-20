# state-backend/storage-backend

Bootstraps the Azure resources needed for a Terraform `azurerm` remote
state backend: a resource group (optionally created, or an existing one
by name), a storage account with public network access disabled by
default, TLS 1.2 enforced and blob versioning/soft-delete enabled, and a
private container for state blobs. Optionally encrypts the account with
a customer-managed key from an existing Key Vault and grants Storage
Blob Data Contributor to a list of Terraform runner principals.

Because this module creates the very backend a Terraform configuration
would otherwise use, it must be bootstrapped once with local state before
any configuration can point at it:

1. Apply this module with a local backend (or no backend block at all).
2. Note the `backend_config` output.
3. Add a `backend "azurerm" {}` block to the consuming configuration and
   run `terraform init -migrate-state`, passing the values above via
   `-backend-config` or a partial configuration.

## Usage

```hcl
module "state_backend" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/state-backend/storage-backend?ref=v1.0.0"

  resource_group_name  = "platform-tfstate-rg"
  location             = "eastus2"
  storage_account_name = "platformtfstate001"

  allowed_ip_rules = ["203.0.113.10/32"]

  create_role_assignments = true
  runner_principal_ids    = [data.azuread_service_principal.ci.object_id]

  tags = {
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}
```

Resulting backend block a consumer configuration would paste, preferring
Azure AD authentication over storage account access keys:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "platform-tfstate-rg"
    storage_account_name = "platformtfstate001"
    container_name        = "tfstate"
    key                    = "platform.tfstate"
    use_azuread_auth      = true
  }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

# Development environment values. Replace the state storage account name in dev.backend.hcl.
location     = "eastus"
project_name = "azure-iac"
environment  = "dev"

vnet_address_space = ["10.10.0.0/16"]
subnets = {
  dev-app = {
    address_prefixes = ["10.10.1.0/24"]
  }
  dev-data = {
    address_prefixes = ["10.10.2.0/24"]
  }
}
nat_gateway_subnet_keys = ["dev-app"]

storage_account_name          = "REPLACE_WITH_GLOBALLY_UNIQUE_DEV_STORAGE_ACCOUNT"
key_vault_name                = "azure-iac-dev-kv"
function_app_name             = "azure-iac-dev-func"
function_app_os_type          = "Linux"
function_app_service_plan_sku = "Y1"
log_analytics_workspace_name  = "azure-iac-dev-law"

state_backends = {}

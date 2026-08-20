# Production environment values. Replace the state storage account name in prod.backend.hcl.
location     = "eastus"
project_name = "azure-iac"
environment  = "prod"

vnet_address_space = ["10.30.0.0/16"]
subnets = {
  prod-app = {
    address_prefixes = ["10.30.1.0/24"]
  }
  prod-data = {
    address_prefixes = ["10.30.2.0/24"]
  }
}
nat_gateway_subnet_keys = ["prod-app"]

storage_account_name          = "REPLACE_WITH_GLOBALLY_UNIQUE_PROD_STORAGE_ACCOUNT"
key_vault_name                = "azure-iac-prod-kv"
function_app_name             = "azure-iac-prod-func"
function_app_os_type          = "Linux"
function_app_service_plan_sku = "EP1"
log_analytics_workspace_name  = "azure-iac-prod-law"

state_backends = {}

# Test environment values. Replace the state storage account name in test.backend.hcl.
location     = "eastus"
project_name = "azure-iac"
environment  = "test"

vnet_address_space = ["10.20.0.0/16"]
subnets = {
  test-app = {
    address_prefixes = ["10.20.1.0/24"]
  }
  test-data = {
    address_prefixes = ["10.20.2.0/24"]
  }
}
nat_gateway_subnet_keys = ["test-app"]

storage_account_name          = "REPLACE_WITH_GLOBALLY_UNIQUE_TEST_STORAGE_ACCOUNT"
key_vault_name                = "azure-iac-test-kv"
function_app_name             = "azure-iac-test-func"
function_app_os_type          = "Linux"
function_app_service_plan_sku = "Y1"
log_analytics_workspace_name  = "azure-iac-test-law"

state_backends = {}

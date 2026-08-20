# -----------------------------------------------------------------------------
# Shared managed identity for core workloads
# -----------------------------------------------------------------------------

module "function_app_identity" {
  source = "./modules/security/managed-identity"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identities = {
    function_app = {
      name = "${var.project_name}-${var.environment}-function-app"
    }
  }
  tags = local.common_tags
}

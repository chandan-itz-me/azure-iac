# -----------------------------------------------------------------------------
# Key Vault
# -----------------------------------------------------------------------------

data "azurerm_client_config" "current" {}

module "key_vault" {
  source = "./modules/security/key-vault"

  name                = var.key_vault_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tenant_id           = coalesce(var.tenant_id, data.azurerm_client_config.current.tenant_id)
  tags                = local.common_tags
}

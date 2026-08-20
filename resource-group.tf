# -----------------------------------------------------------------------------
# Resource group
# -----------------------------------------------------------------------------

resource "azurerm_resource_group" "this" {
  name     = coalesce(var.resource_group_name, "${var.project_name}-${var.environment}")
  location = var.location

  tags = local.common_tags
}

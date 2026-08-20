resource "azurerm_role_definition" "this" {
  for_each = var.custom_role_definitions

  name        = each.value.name
  scope       = each.value.scope
  description = each.value.description

  permissions {
    actions          = each.value.permissions.actions
    not_actions      = each.value.permissions.not_actions
    data_actions     = each.value.permissions.data_actions
    not_data_actions = each.value.permissions.not_data_actions
  }

  assignable_scopes = each.value.assignable_scopes
}

resource "azurerm_role_assignment" "this" {
  for_each = var.assignments

  scope                = each.value.scope
  role_definition_name = each.value.custom_role_key == null ? each.value.role_definition_name : null
  role_definition_id   = each.value.custom_role_key != null ? azurerm_role_definition.this[each.value.custom_role_key].role_definition_resource_id : each.value.role_definition_id
  principal_id         = each.value.principal_id
  principal_type       = each.value.principal_type
  condition            = each.value.condition
  condition_version    = each.value.condition != null ? coalesce(each.value.condition_version, "2.0") : null
  description          = each.value.description
}

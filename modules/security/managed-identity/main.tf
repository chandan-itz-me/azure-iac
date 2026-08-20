resource "azurerm_user_assigned_identity" "this" {
  for_each = var.identities

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = merge(var.tags, { Name = each.value.name })
}

resource "azurerm_federated_identity_credential" "this" {
  for_each = var.federated_credentials

  name                = each.key
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.this[each.value.identity_key].id
  issuer              = each.value.issuer
  subject             = each.value.subject
  audience            = each.value.audiences
}

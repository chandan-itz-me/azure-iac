resource "random_password" "this" {
  for_each = nonsensitive(var.secrets)

  length  = each.value.generated_length
  special = each.value.generated_special
}

resource "azurerm_key_vault_secret" "this" {
  for_each = nonsensitive(var.secrets)

  name            = each.key
  key_vault_id    = var.key_vault_id
  value           = each.value.generate_value ? random_password.this[each.key].result : var.secrets[each.key].value
  content_type    = each.value.content_type
  expiration_date = each.value.expiration_date
  not_before_date = each.value.not_before_date

  tags = var.tags
}

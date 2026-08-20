# -----------------------------------------------------------------------------
# Security resources
# -----------------------------------------------------------------------------

module "key_vault_certificates" {
  for_each = var.key_vault_certificates
  source   = "./modules/security/key-vault-certificate"

  key_vault_id = module.key_vault.id
  certificates = each.value.certificates
}

module "key_vault_secrets" {
  for_each = nonsensitive(var.key_vault_secrets)
  source   = "./modules/security/key-vault-secret"

  key_vault_id = module.key_vault.id
  secrets      = each.value.secrets
  tags         = local.common_tags
}

module "role_assignments" {
  for_each = var.role_assignments
  source   = "./modules/security/role-assignment"

  assignments = {
    for assignment_key, assignment in each.value.assignments : assignment_key => merge(assignment, {
      principal_id = try(assignment.principal_id, null) != null ? assignment.principal_id : local.workload_identity_principal_ids[assignment.principal_identity_key]
    })
  }
  custom_role_definitions = try(each.value.custom_role_definitions, {})
}

module "managed_identities" {
  for_each = var.managed_identities
  source   = "./modules/security/managed-identity"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identities          = each.value.identities
  tags                = local.common_tags
}

resource "azurerm_key_vault_certificate" "this" {
  for_each = var.certificates

  name         = each.key
  key_vault_id = var.key_vault_id

  dynamic "certificate" {
    for_each = each.value.import != null ? [each.value.import] : []

    content {
      contents = certificate.value.contents
      password = certificate.value.password
    }
  }

  certificate_policy {
    issuer_parameters {
      name = each.value.certificate_policy.issuer_name
    }

    key_properties {
      exportable = each.value.certificate_policy.exportable
      key_type   = each.value.certificate_policy.key_type
      key_size   = each.value.certificate_policy.key_size
      curve      = each.value.certificate_policy.curve
      reuse_key  = each.value.certificate_policy.reuse_key
    }

    secret_properties {
      content_type = each.value.certificate_policy.content_type
    }

    x509_certificate_properties {
      subject            = each.value.certificate_policy.subject
      validity_in_months = each.value.certificate_policy.validity_in_months
      key_usage          = each.value.certificate_policy.key_usage
      extended_key_usage = each.value.certificate_policy.extended_key_usage

      dynamic "subject_alternative_names" {
        for_each = each.value.certificate_policy.subject_alternative_names != null ? [each.value.certificate_policy.subject_alternative_names] : []

        content {
          dns_names = subject_alternative_names.value.dns_names
          emails    = subject_alternative_names.value.emails
          upns      = subject_alternative_names.value.upns
        }
      }
    }

    lifetime_action {
      action {
        action_type = each.value.certificate_policy.lifetime_action.action_type
      }

      trigger {
        lifetime_percentage = each.value.certificate_policy.lifetime_action.lifetime_percentage
        days_before_expiry  = each.value.certificate_policy.lifetime_action.days_before_expiry
      }
    }
  }

  tags = var.tags
}

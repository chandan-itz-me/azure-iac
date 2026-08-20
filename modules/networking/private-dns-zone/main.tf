resource "azurerm_private_dns_zone" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name

  tags = merge(var.tags, { Name = var.name })
}

resource "azurerm_private_dns_a_record" "this" {
  for_each = { for k, v in var.records : k => v if v.type == "A" }

  name                = each.key
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.values
}

resource "azurerm_private_dns_aaaa_record" "this" {
  for_each = { for k, v in var.records : k => v if v.type == "AAAA" }

  name                = each.key
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.values
}

resource "azurerm_private_dns_cname_record" "this" {
  for_each = { for k, v in var.records : k => v if v.type == "CNAME" }

  name                = each.key
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  record              = each.value.values[0]
}

resource "azurerm_private_dns_ptr_record" "this" {
  for_each = { for k, v in var.records : k => v if v.type == "PTR" }

  name                = each.key
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.values
}

resource "azurerm_private_dns_mx_record" "this" {
  for_each = { for k, v in var.records : k => v if v.type == "MX" }

  name                = each.key
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = each.value.mx_records
    content {
      preference = record.value.preference
      exchange   = record.value.exchange
    }
  }
}

resource "azurerm_private_dns_srv_record" "this" {
  for_each = { for k, v in var.records : k => v if v.type == "SRV" }

  name                = each.key
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = each.value.srv_records
    content {
      priority = record.value.priority
      weight   = record.value.weight
      port     = record.value.port
      target   = record.value.target
    }
  }
}

resource "azurerm_private_dns_txt_record" "this" {
  for_each = { for k, v in var.records : k => v if v.type == "TXT" }

  name                = each.key
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = each.value.txt_records
    content {
      value = record.value.value
    }
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = var.virtual_network_links

  name                  = each.key
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = each.value.virtual_network_id
  registration_enabled  = each.value.registration_enabled

  tags = merge(var.tags, { Name = each.key })
}

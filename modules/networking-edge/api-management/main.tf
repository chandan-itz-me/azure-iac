resource "azurerm_api_management" "this" {
  name                 = var.name
  resource_group_name  = var.resource_group_name
  location             = var.location
  publisher_name       = var.publisher_name
  publisher_email      = var.publisher_email
  sku_name             = var.sku_name
  virtual_network_type = var.virtual_network_type
  min_api_version      = var.min_api_version

  dynamic "virtual_network_configuration" {
    for_each = var.virtual_network_type != "None" ? [var.subnet_id] : []

    content {
      subnet_id = virtual_network_configuration.value
    }
  }

  identity {
    type         = var.identity_type
    identity_ids = strcontains(var.identity_type, "UserAssigned") ? var.identity_ids : null
  }

  security {
    enable_backend_ssl30       = var.security_protocols.enable_backend_ssl30
    enable_backend_tls10       = var.security_protocols.enable_backend_tls10
    enable_backend_tls11       = var.security_protocols.enable_backend_tls11
    enable_frontend_ssl30      = var.security_protocols.enable_frontend_ssl30
    enable_frontend_tls10      = var.security_protocols.enable_frontend_tls10
    enable_frontend_tls11      = var.security_protocols.enable_frontend_tls11
    triple_des_ciphers_enabled = var.security_protocols.enable_triple_des_ciphers
  }

  tags = merge(var.tags, { Name = var.name })
}

resource "azurerm_api_management_custom_domain" "this" {
  count = var.custom_domain_gateway != null ? 1 : 0

  api_management_id = azurerm_api_management.this.id

  gateway {
    host_name                    = var.custom_domain_gateway.host_name
    key_vault_id                 = var.custom_domain_gateway.key_vault_secret_id
    negotiate_client_certificate = var.custom_domain_gateway.negotiate_client_certificate
  }
}

resource "azurerm_api_management_api" "this" {
  for_each = var.apis

  name                = each.key
  api_management_name = azurerm_api_management.this.name
  resource_group_name = var.resource_group_name
  display_name        = each.value.display_name
  path                = each.value.path
  revision            = each.value.revision
  protocols           = each.value.protocols
  service_url         = each.value.service_url

  dynamic "import" {
    for_each = each.value.import != null ? [each.value.import] : []

    content {
      content_format = import.value.content_format
      content_value  = import.value.content_value
    }
  }
}

resource "azurerm_api_management_product" "this" {
  for_each = var.products

  product_id            = each.key
  api_management_name   = azurerm_api_management.this.name
  resource_group_name   = var.resource_group_name
  display_name          = each.value.display_name
  description           = each.value.description
  subscription_required = each.value.subscription_required
  approval_required     = each.value.approval_required
  published             = each.value.published
}

resource "azurerm_api_management_product_api" "this" {
  for_each = { for pair in flatten([
    for product_key, product in var.products : [
      for api_key in product.api_keys : {
        key         = "${product_key}-${api_key}"
        product_key = product_key
        api_key     = api_key
      }
    ]
  ]) : pair.key => pair }

  api_name            = azurerm_api_management_api.this[each.value.api_key].name
  product_id          = azurerm_api_management_product.this[each.value.product_key].product_id
  api_management_name = azurerm_api_management.this.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_api_management_named_value" "this" {
  for_each = toset(nonsensitive(keys(var.named_values)))

  name                = each.value
  api_management_name = azurerm_api_management.this.name
  resource_group_name = var.resource_group_name
  display_name        = var.named_values[each.value].display_name
  value               = var.named_values[each.value].value
  secret              = var.named_values[each.value].secret
}

resource "azurerm_api_management_backend" "this" {
  for_each = var.backends

  name                = each.key
  api_management_name = azurerm_api_management.this.name
  resource_group_name = var.resource_group_name
  protocol            = each.value.protocol
  url                 = each.value.url
  description         = each.value.description
  resource_id         = each.value.resource_id
}

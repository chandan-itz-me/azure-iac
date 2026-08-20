locals {
  frontend_ports = distinct([for k, v in var.http_listeners : v.frontend_port])

  ssl_certificates = {
    for k, v in var.http_listeners : k => v.key_vault_secret_id
    if v.key_vault_secret_id != null
  }
}

resource "azurerm_public_ip" "this" {
  count = var.create_public_ip ? 1 : 0

  name                = "${var.name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku

  tags = var.tags
}

resource "azurerm_application_gateway" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = var.sku_name
    tier     = var.sku_name
    capacity = null
  }

  autoscale_configuration {
    min_capacity = var.autoscale_min_capacity
    max_capacity = var.autoscale_max_capacity
  }

  gateway_ip_configuration {
    name      = "gateway-ip-configuration"
    subnet_id = var.subnet_id
  }

  frontend_ip_configuration {
    name                 = "public-frontend"
    public_ip_address_id = var.create_public_ip ? azurerm_public_ip.this[0].id : var.public_ip_id
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.private_ip_address != null ? [var.private_ip_address] : []

    content {
      name                          = "private-frontend"
      subnet_id                     = var.subnet_id
      private_ip_address            = frontend_ip_configuration.value
      private_ip_address_allocation = "Static"
    }
  }

  dynamic "frontend_port" {
    for_each = local.frontend_ports

    content {
      name = "port-${frontend_port.value}"
      port = frontend_port.value
    }
  }

  dynamic "ssl_certificate" {
    for_each = local.ssl_certificates

    content {
      name                = ssl_certificate.key
      key_vault_secret_id = ssl_certificate.value
    }
  }

  dynamic "identity" {
    for_each = length(var.identity_ids) > 0 ? [1] : []

    content {
      type         = "UserAssigned"
      identity_ids = var.identity_ids
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools

    content {
      name         = backend_address_pool.key
      ip_addresses = backend_address_pool.value.ip_addresses
      fqdns        = backend_address_pool.value.fqdns
    }
  }

  dynamic "probe" {
    for_each = var.probes

    content {
      name                                      = probe.key
      protocol                                  = probe.value.protocol
      path                                      = probe.value.path
      host                                      = probe.value.host
      interval                                  = probe.value.interval
      timeout                                   = probe.value.timeout
      unhealthy_threshold                       = probe.value.unhealthy_threshold
      pick_host_name_from_backend_http_settings = probe.value.host == null
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings

    content {
      name                  = backend_http_settings.key
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      request_timeout       = backend_http_settings.value.request_timeout
      path                  = backend_http_settings.value.path
      host_name             = backend_http_settings.value.host_name
      probe_name            = backend_http_settings.value.probe_key
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listeners

    content {
      name                           = http_listener.key
      frontend_ip_configuration_name = http_listener.value.use_private_frontend ? "private-frontend" : "public-frontend"
      frontend_port_name             = "port-${http_listener.value.frontend_port}"
      protocol                       = http_listener.value.protocol
      host_name                      = http_listener.value.host_name
      require_sni                    = http_listener.value.require_sni
      ssl_certificate_name           = http_listener.value.key_vault_secret_id != null ? http_listener.key : null
    }
  }

  dynamic "redirect_configuration" {
    for_each = var.redirect_configurations

    content {
      name                 = redirect_configuration.key
      redirect_type        = redirect_configuration.value.redirect_type
      target_listener_name = redirect_configuration.value.target_listener_key
      target_url           = redirect_configuration.value.target_url
      include_path         = redirect_configuration.value.include_path
      include_query_string = redirect_configuration.value.include_query_string
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rules

    content {
      name                        = request_routing_rule.key
      rule_type                   = request_routing_rule.value.rule_type
      priority                    = request_routing_rule.value.priority
      http_listener_name          = request_routing_rule.value.http_listener_key
      backend_address_pool_name   = request_routing_rule.value.backend_address_pool_key
      backend_http_settings_name  = request_routing_rule.value.backend_http_settings_key
      redirect_configuration_name = request_routing_rule.value.redirect_configuration_key
    }
  }

  dynamic "waf_configuration" {
    for_each = var.waf_configuration != null ? [var.waf_configuration] : []

    content {
      enabled          = waf_configuration.value.enabled
      firewall_mode    = waf_configuration.value.firewall_mode
      rule_set_type    = "OWASP"
      rule_set_version = waf_configuration.value.rule_set_version

      dynamic "disabled_rule_group" {
        for_each = waf_configuration.value.disabled_rule_group

        content {
          rule_group_name = disabled_rule_group.value.rule_group_name
          rules           = disabled_rule_group.value.rules
        }
      }
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

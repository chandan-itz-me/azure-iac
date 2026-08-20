resource "azurerm_service_plan" "this" {
  count = var.create_service_plan ? 1 : 0

  name                = "${var.name}-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type == "linux" ? "Linux" : "Windows"
  sku_name            = var.sku_name

  tags = var.tags
}

resource "azurerm_linux_web_app" "this" {
  count = var.os_type == "linux" ? 1 : 0

  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  service_plan_id           = var.create_service_plan ? azurerm_service_plan.this[0].id : var.service_plan_id
  virtual_network_subnet_id = var.virtual_network_subnet_id
  https_only                = var.https_only
  app_settings              = var.app_settings

  site_config {
    always_on           = var.always_on
    http2_enabled       = var.http2_enabled
    minimum_tls_version = var.minimum_tls_version

    application_stack {
      dotnet_version = var.dotnet_version
      node_version   = var.node_version
      python_version = var.python_version
      java_version   = var.java_version
      php_version    = var.php_version
    }
  }

  dynamic "connection_string" {
    for_each = var.connection_strings

    content {
      name  = connection_string.key
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "identity" {
    for_each = var.identity_type != "None" ? [1] : []

    content {
      type         = var.identity_type
      identity_ids = strcontains(var.identity_type, "UserAssigned") ? var.identity_ids : null
    }
  }

  dynamic "sticky_settings" {
    for_each = var.sticky_settings != null ? [var.sticky_settings] : []

    content {
      app_setting_names       = sticky_settings.value.app_setting_names
      connection_string_names = sticky_settings.value.connection_string_names
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

resource "azurerm_windows_web_app" "this" {
  count = var.os_type == "windows" ? 1 : 0

  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  service_plan_id           = var.create_service_plan ? azurerm_service_plan.this[0].id : var.service_plan_id
  virtual_network_subnet_id = var.virtual_network_subnet_id
  https_only                = var.https_only
  app_settings              = var.app_settings

  site_config {
    always_on           = var.always_on
    http2_enabled       = var.http2_enabled
    minimum_tls_version = var.minimum_tls_version

    application_stack {
      dotnet_version = var.dotnet_version
      java_version   = var.java_version
    }
  }

  dynamic "connection_string" {
    for_each = var.connection_strings

    content {
      name  = connection_string.key
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "identity" {
    for_each = var.identity_type != "None" ? [1] : []

    content {
      type         = var.identity_type
      identity_ids = strcontains(var.identity_type, "UserAssigned") ? var.identity_ids : null
    }
  }

  dynamic "sticky_settings" {
    for_each = var.sticky_settings != null ? [var.sticky_settings] : []

    content {
      app_setting_names       = sticky_settings.value.app_setting_names
      connection_string_names = sticky_settings.value.connection_string_names
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

resource "azurerm_app_service_custom_hostname_binding" "this" {
  count = var.custom_domain != null ? 1 : 0

  hostname            = var.custom_domain.hostname
  app_service_name    = var.os_type == "linux" ? azurerm_linux_web_app.this[0].name : azurerm_windows_web_app.this[0].name
  resource_group_name = var.resource_group_name
}

resource "azurerm_app_service_managed_certificate" "this" {
  count = var.custom_domain != null ? 1 : 0

  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.this[0].id
}

resource "azurerm_app_service_certificate_binding" "this" {
  count = var.custom_domain != null ? 1 : 0

  hostname_binding_id = azurerm_app_service_custom_hostname_binding.this[0].id
  certificate_id      = azurerm_app_service_managed_certificate.this[0].id
  ssl_state           = "SniEnabled"
}

resource "azurerm_linux_web_app_slot" "this" {
  for_each = var.os_type == "linux" ? var.deployment_slots : {}

  name           = each.key
  app_service_id = azurerm_linux_web_app.this[0].id
  app_settings   = each.value.app_settings

  site_config {
    always_on           = var.always_on
    http2_enabled       = var.http2_enabled
    minimum_tls_version = var.minimum_tls_version

    application_stack {
      dotnet_version = var.dotnet_version
      node_version   = var.node_version
      python_version = var.python_version
      java_version   = var.java_version
      php_version    = var.php_version
    }
  }

  tags = var.tags
}

resource "azurerm_windows_web_app_slot" "this" {
  for_each = var.os_type == "windows" ? var.deployment_slots : {}

  name           = each.key
  app_service_id = azurerm_windows_web_app.this[0].id
  app_settings   = each.value.app_settings

  site_config {
    always_on           = var.always_on
    http2_enabled       = var.http2_enabled
    minimum_tls_version = var.minimum_tls_version

    application_stack {
      dotnet_version = var.dotnet_version
      java_version   = var.java_version
    }
  }

  tags = var.tags
}

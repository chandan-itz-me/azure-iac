resource "azurerm_service_plan" "this" {
  count = var.create_service_plan ? 1 : 0

  name                = "${var.name}-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type == "linux" ? "Linux" : "Windows"
  sku_name            = var.sku_name

  tags = var.tags
}

resource "azurerm_linux_function_app" "this" {
  count = var.os_type == "linux" ? 1 : 0

  name                       = var.name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  service_plan_id            = var.create_service_plan ? azurerm_service_plan.this[0].id : var.service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  virtual_network_subnet_id  = var.virtual_network_subnet_id
  https_only                 = var.https_only
  app_settings               = var.app_settings

  site_config {
    application_stack {
      dotnet_version = var.dotnet_version
      node_version   = var.node_version
      python_version = var.python_version
      java_version   = var.java_version
    }
  }

  dynamic "identity" {
    for_each = var.identity_type != "None" ? [1] : []

    content {
      type         = var.identity_type
      identity_ids = strcontains(var.identity_type, "UserAssigned") ? var.identity_ids : null
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

resource "azurerm_windows_function_app" "this" {
  count = var.os_type == "windows" ? 1 : 0

  name                       = var.name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  service_plan_id            = var.create_service_plan ? azurerm_service_plan.this[0].id : var.service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  virtual_network_subnet_id  = var.virtual_network_subnet_id
  https_only                 = var.https_only
  app_settings               = var.app_settings

  site_config {
    application_stack {
      dotnet_version = var.dotnet_version
      node_version   = var.node_version
      java_version   = var.java_version
    }
  }

  dynamic "identity" {
    for_each = var.identity_type != "None" ? [1] : []

    content {
      type         = var.identity_type
      identity_ids = strcontains(var.identity_type, "UserAssigned") ? var.identity_ids : null
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

resource "azurerm_linux_function_app_slot" "this" {
  for_each = var.os_type == "linux" ? var.function_app_slots : {}

  name                       = each.key
  function_app_id            = azurerm_linux_function_app.this[0].id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  app_settings               = each.value.app_settings

  site_config {
    application_stack {
      dotnet_version = var.dotnet_version
      node_version   = var.node_version
      python_version = var.python_version
      java_version   = var.java_version
    }
  }

  tags = var.tags
}

resource "azurerm_windows_function_app_slot" "this" {
  for_each = var.os_type == "windows" ? var.function_app_slots : {}

  name                       = each.key
  function_app_id            = azurerm_windows_function_app.this[0].id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  app_settings               = each.value.app_settings

  site_config {
    application_stack {
      dotnet_version = var.dotnet_version
      node_version   = var.node_version
      java_version   = var.java_version
    }
  }

  tags = var.tags
}

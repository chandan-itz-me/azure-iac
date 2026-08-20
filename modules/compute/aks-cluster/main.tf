resource "azurerm_kubernetes_cluster" "this" {
  name                    = var.name
  resource_group_name     = var.resource_group_name
  location                = var.location
  dns_prefix              = var.dns_prefix
  kubernetes_version      = var.kubernetes_version
  private_cluster_enabled = var.private_cluster_enabled
  azure_policy_enabled    = true

  sku_tier                  = "Standard"
  automatic_channel_upgrade = var.automatic_channel_upgrade

  default_node_pool {
    name                         = "system"
    vm_size                      = var.default_node_pool.vm_size
    node_count                   = var.default_node_pool.enable_auto_scaling ? null : var.default_node_pool.node_count
    enable_auto_scaling          = var.default_node_pool.enable_auto_scaling
    min_count                    = var.default_node_pool.enable_auto_scaling ? var.default_node_pool.min_count : null
    max_count                    = var.default_node_pool.enable_auto_scaling ? var.default_node_pool.max_count : null
    os_disk_size_gb              = var.default_node_pool.os_disk_size_gb
    only_critical_addons_enabled = var.default_node_pool.only_critical_addons_enabled
    vnet_subnet_id               = var.default_node_pool.vnet_subnet_id
    zones                        = var.default_node_pool.zones
  }

  identity {
    type         = var.identity_type
    identity_ids = var.identity_type == "UserAssigned" ? var.identity_ids : null
  }

  network_profile {
    network_plugin = var.network_plugin
    network_policy = var.network_policy
    service_cidr   = var.service_cidr
    dns_service_ip = var.dns_service_ip
    outbound_type  = var.outbound_type
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = var.azure_rbac_enabled
    admin_group_object_ids = var.admin_group_object_ids
  }

  dynamic "oms_agent" {
    for_each = var.log_analytics_workspace_id != null ? [var.log_analytics_workspace_id] : []

    content {
      log_analytics_workspace_id = oms_agent.value
    }
  }

  api_server_access_profile {
    authorized_ip_ranges = var.authorized_ip_ranges
  }

  dynamic "maintenance_window" {
    for_each = var.maintenance_window != null ? [var.maintenance_window] : []

    content {
      dynamic "allowed" {
        for_each = maintenance_window.value.allowed

        content {
          day   = allowed.value.day
          hours = allowed.value.hours
        }
      }
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = var.key_vault_secrets_provider_enabled ? [1] : []

    content {
      secret_rotation_enabled = var.secret_rotation_enabled
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = var.additional_node_pools

  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = each.value.vm_size
  node_count            = each.value.enable_auto_scaling ? null : each.value.node_count
  enable_auto_scaling   = each.value.enable_auto_scaling
  min_count             = each.value.enable_auto_scaling ? each.value.min_count : null
  max_count             = each.value.enable_auto_scaling ? each.value.max_count : null
  mode                  = each.value.mode
  zones                 = each.value.zones
  vnet_subnet_id        = each.value.vnet_subnet_id
  node_taints           = each.value.node_taints
  node_labels           = each.value.node_labels

  tags = var.tags
}

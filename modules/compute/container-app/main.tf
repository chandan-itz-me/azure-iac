resource "azurerm_container_app_environment" "this" {
  count = var.create_environment ? 1 : 0

  name                           = "${var.name}-env"
  resource_group_name            = var.resource_group_name
  location                       = var.location
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  internal_load_balancer_enabled = var.internal_load_balancer_enabled
  infrastructure_subnet_id       = var.infrastructure_subnet_id

  tags = var.tags
}

resource "azurerm_container_app" "this" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.create_environment ? azurerm_container_app_environment.this[0].id : var.container_app_environment_id
  revision_mode                = var.revision_mode

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    dynamic "container" {
      for_each = var.containers

      content {
        name   = container.key
        image  = container.value.image
        cpu    = container.value.cpu
        memory = container.value.memory

        dynamic "env" {
          for_each = container.value.env

          content {
            name  = env.key
            value = env.value
          }
        }

        dynamic "env" {
          for_each = container.value.secret_env

          content {
            name        = env.key
            secret_name = env.value
          }
        }

        dynamic "liveness_probe" {
          for_each = container.value.liveness_probe != null ? [container.value.liveness_probe] : []

          content {
            transport = liveness_probe.value.transport
            port      = liveness_probe.value.port
            path      = liveness_probe.value.path
          }
        }

        dynamic "readiness_probe" {
          for_each = container.value.readiness_probe != null ? [container.value.readiness_probe] : []

          content {
            transport = readiness_probe.value.transport
            port      = readiness_probe.value.port
            path      = readiness_probe.value.path
          }
        }
      }
    }
  }

  dynamic "ingress" {
    for_each = var.ingress != null ? [var.ingress] : []

    content {
      external_enabled = ingress.value.external_enabled
      target_port      = ingress.value.target_port
      transport        = ingress.value.transport

      dynamic "traffic_weight" {
        for_each = ingress.value.traffic_weight

        content {
          latest_revision = traffic_weight.value.latest_revision
          percentage      = traffic_weight.value.percentage
        }
      }
    }
  }

  dynamic "secret" {
    for_each = var.secrets

    content {
      name  = secret.key
      value = secret.value
    }
  }

  dynamic "identity" {
    for_each = var.identity_type != "None" ? [1] : []

    content {
      type         = var.identity_type
      identity_ids = strcontains(var.identity_type, "UserAssigned") ? var.identity_ids : null
    }
  }

  dynamic "dapr" {
    for_each = var.dapr != null ? [var.dapr] : []

    content {
      app_id       = dapr.value.app_id
      app_port     = dapr.value.app_port
      app_protocol = dapr.value.app_protocol
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

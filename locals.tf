locals {
  common_tags = merge(
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "terraform"
    },
    var.common_tags,
  )

  # Identity references use "module-key.identity-key" so workloads can attach
  # identities created by any managed-identity module instance.
  managed_identity_ids = merge([
    for module_key, identity_module in module.managed_identities : {
      for identity_key, identity_id in identity_module.identity_ids :
      "${module_key}.${identity_key}" => identity_id
    }
  ]...)

  managed_identity_principal_ids = merge([
    for module_key, identity_module in module.managed_identities : {
      for identity_key, principal_id in identity_module.principal_ids :
      "${module_key}.${identity_key}" => principal_id
    }
  ]...)

  workload_identity_principal_ids = merge(
    { function_app = module.function_app_identity.principal_ids["function_app"] },
    local.managed_identity_principal_ids,
    merge([
      for key, identity_module in module.virtual_machine_identities :
      { "virtual_machines.${key}" = identity_module.principal_ids["workload"] }
    ]...),
    merge([
      for key, identity_module in module.vmss_identities :
      { "vmss.${key}" = identity_module.principal_ids["workload"] }
    ]...),
    merge([
      for key, identity_module in module.aks_identities :
      { "aks_clusters.${key}" = identity_module.principal_ids["workload"] }
    ]...),
    merge([
      for key, identity_module in module.container_app_identities :
      { "container_apps.${key}" = identity_module.principal_ids["workload"] }
    ]...),
    merge([
      for key, identity_module in module.app_service_identities :
      { "app_services.${key}" = identity_module.principal_ids["workload"] }
    ]...),
    merge([
      for key, identity_module in module.cosmos_db_identities :
      { "cosmos_dbs.${key}" = identity_module.principal_ids["workload"] }
    ]...),
    merge([
      for key, identity_module in module.sql_identities :
      { "sql_databases.${key}" = identity_module.principal_ids["workload"] }
    ]...),
    merge([
      for key, identity_module in module.service_bus_identities :
      { "service_bus_namespaces.${key}" = identity_module.principal_ids["workload"] }
    ]...),
    merge([
      for key, identity_module in module.event_grid_identities :
      { "event_grids.${key}" = identity_module.principal_ids["workload"] }
    ]...),
    merge([
      for key, identity_module in module.event_hub_identities :
      { "event_hubs.${key}" = identity_module.principal_ids["workload"] }
    ]...),
    merge([
      for key, identity_module in module.application_gateway_identities :
      { "application_gateways.${key}" = identity_module.principal_ids["workload"] }
    ]...),
    merge([
      for key, identity_module in module.api_management_identities :
      { "api_managements.${key}" = identity_module.principal_ids["workload"] }
    ]...),
  )
}

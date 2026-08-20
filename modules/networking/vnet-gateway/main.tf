resource "azurerm_public_ip" "this" {
  name                = "${var.name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = var.public_ip_sku
  zones               = var.zones

  tags = merge(var.tags, { Name = "${var.name}-pip" })
}

resource "azurerm_virtual_network_gateway" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  type          = var.type
  vpn_type      = var.vpn_type
  active_active = var.active_active
  enable_bgp    = var.enable_bgp
  sku           = var.sku
  generation    = var.generation

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.this.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }

  dynamic "vpn_client_configuration" {
    for_each = var.vpn_client_configuration != null ? [var.vpn_client_configuration] : []

    content {
      address_space        = vpn_client_configuration.value.address_space
      vpn_client_protocols = vpn_client_configuration.value.vpn_client_protocols
      aad_tenant           = vpn_client_configuration.value.aad_tenant
      aad_audience         = vpn_client_configuration.value.aad_audience
      aad_issuer           = vpn_client_configuration.value.aad_issuer

      dynamic "root_certificate" {
        for_each = vpn_client_configuration.value.root_certificates

        content {
          name             = root_certificate.value.name
          public_cert_data = root_certificate.value.public_cert_data
        }
      }

      dynamic "revoked_certificate" {
        for_each = vpn_client_configuration.value.revoked_certificates

        content {
          name       = revoked_certificate.value.name
          thumbprint = revoked_certificate.value.thumbprint
        }
      }
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

resource "azurerm_local_network_gateway" "this" {
  for_each = var.create_site_to_site ? var.local_network_gateways : {}

  name                = "${var.name}-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.location
  gateway_address     = each.value.gateway_address
  gateway_fqdn        = each.value.gateway_fqdn
  address_space       = each.value.address_space

  dynamic "bgp_settings" {
    for_each = each.value.bgp_settings != null ? [each.value.bgp_settings] : []

    content {
      asn                 = bgp_settings.value.asn
      bgp_peering_address = bgp_settings.value.bgp_peering_address
    }
  }

  tags = merge(var.tags, { Name = "${var.name}-${each.key}" })
}

resource "azurerm_virtual_network_gateway_connection" "this" {
  for_each = var.create_site_to_site ? var.connections : {}

  name                       = "${var.name}-${each.key}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.this.id
  local_network_gateway_id   = azurerm_local_network_gateway.this[each.value.local_network_gateway_key].id
  shared_key                 = each.value.shared_key
  connection_protocol        = each.value.connection_protocol
  enable_bgp                 = each.value.enable_bgp

  tags = merge(var.tags, { Name = "${var.name}-${each.key}" })
}

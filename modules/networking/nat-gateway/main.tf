resource "azurerm_nat_gateway" "this" {
  name                    = var.name
  resource_group_name     = var.resource_group_name
  location                = var.location
  sku_name                = var.sku_name
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  zones                   = var.zones

  tags = merge(var.tags, { Name = var.name })
}

resource "azurerm_public_ip" "this" {
  for_each = var.public_ip_names

  name                = each.value
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.zones

  tags = merge(var.tags, { Name = each.value })
}

resource "azurerm_nat_gateway_public_ip_association" "created" {
  for_each = azurerm_public_ip.this

  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = each.value.id
}

resource "azurerm_nat_gateway_public_ip_association" "existing" {
  for_each = var.existing_public_ip_ids

  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = each.value
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "this" {
  count = var.public_ip_prefix_id != null ? 1 : 0

  nat_gateway_id      = azurerm_nat_gateway.this.id
  public_ip_prefix_id = var.public_ip_prefix_id
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each = var.subnet_ids

  subnet_id      = each.value
  nat_gateway_id = azurerm_nat_gateway.this.id
}

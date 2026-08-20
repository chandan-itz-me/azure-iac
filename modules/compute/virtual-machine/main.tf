resource "random_password" "this" {
  count = var.generate_admin_password ? 1 : 0

  length      = 20
  special     = true
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 1
}

resource "azurerm_public_ip" "this" {
  count = var.public_ip_enabled ? 1 : 0

  name                = "${var.name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
  zones               = var.availability_zone != null ? [var.availability_zone] : null

  tags = var.tags
}

resource "azurerm_network_interface" "this" {
  name                = "${var.name}-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address != null ? "Static" : "Dynamic"
    private_ip_address            = var.private_ip_address
    public_ip_address_id          = var.public_ip_enabled ? azurerm_public_ip.this[0].id : null
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "this" {
  count = var.os_type == "linux" ? 1 : 0

  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.size
  admin_username                  = var.admin_username
  network_interface_ids           = [azurerm_network_interface.this.id]
  zone                            = var.availability_zone
  custom_data                     = var.custom_data
  disable_password_authentication = true

  dynamic "admin_ssh_key" {
    for_each = var.admin_ssh_public_key != null ? [var.admin_ssh_public_key] : []

    content {
      username   = var.admin_username
      public_key = admin_ssh_key.value
    }
  }

  os_disk {
    name                   = "${var.name}-osdisk"
    caching                = var.os_disk.caching
    storage_account_type   = var.os_disk.storage_account_type
    disk_size_gb           = var.os_disk.disk_size_gb
    disk_encryption_set_id = var.os_disk.disk_encryption_set_id
  }

  dynamic "source_image_reference" {
    for_each = var.source_image_reference != null ? [var.source_image_reference] : []

    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  source_image_id = var.source_image_reference == null ? var.source_image_id : null

  dynamic "identity" {
    for_each = var.identity_type != "None" ? [1] : []

    content {
      type         = var.identity_type
      identity_ids = strcontains(var.identity_type, "UserAssigned") ? var.identity_ids : null
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics_enabled ? [1] : []

    content {
      storage_account_uri = var.boot_diagnostics_storage_account_uri
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

resource "azurerm_windows_virtual_machine" "this" {
  count = var.os_type == "windows" ? 1 : 0

  name                  = var.name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.size
  admin_username        = var.admin_username
  admin_password        = coalesce(var.admin_password, try(random_password.this[0].result, null))
  network_interface_ids = [azurerm_network_interface.this.id]
  zone                  = var.availability_zone
  custom_data           = var.custom_data

  os_disk {
    name                   = "${var.name}-osdisk"
    caching                = var.os_disk.caching
    storage_account_type   = var.os_disk.storage_account_type
    disk_size_gb           = var.os_disk.disk_size_gb
    disk_encryption_set_id = var.os_disk.disk_encryption_set_id
  }

  dynamic "source_image_reference" {
    for_each = var.source_image_reference != null ? [var.source_image_reference] : []

    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  source_image_id = var.source_image_reference == null ? var.source_image_id : null

  dynamic "identity" {
    for_each = var.identity_type != "None" ? [1] : []

    content {
      type         = var.identity_type
      identity_ids = strcontains(var.identity_type, "UserAssigned") ? var.identity_ids : null
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics_enabled ? [1] : []

    content {
      storage_account_uri = var.boot_diagnostics_storage_account_uri
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

resource "azurerm_managed_disk" "data" {
  for_each = var.data_disks

  name                 = "${var.name}-${each.key}"
  resource_group_name  = var.resource_group_name
  location             = var.location
  storage_account_type = each.value.storage_account_type
  disk_size_gb         = each.value.disk_size_gb
  create_option        = "Empty"

  tags = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "data" {
  for_each = var.data_disks

  managed_disk_id    = azurerm_managed_disk.data[each.key].id
  virtual_machine_id = var.os_type == "linux" ? azurerm_linux_virtual_machine.this[0].id : azurerm_windows_virtual_machine.this[0].id
  lun                = each.value.lun
  caching            = each.value.caching
}

resource "azurerm_virtual_machine_extension" "this" {
  for_each = var.extensions

  name                       = each.key
  virtual_machine_id         = var.os_type == "linux" ? azurerm_linux_virtual_machine.this[0].id : azurerm_windows_virtual_machine.this[0].id
  publisher                  = each.value.publisher
  type                       = each.value.type
  type_handler_version       = each.value.type_handler_version
  auto_upgrade_minor_version = each.value.auto_upgrade_minor_version
  settings                   = each.value.settings
  protected_settings         = each.value.protected_settings

  tags = var.tags
}

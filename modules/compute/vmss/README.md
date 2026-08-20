# compute/vmss

Creates a Linux or Windows virtual machine scale set in Uniform or Flexible orchestration mode,
with an optional CPU-based autoscale setting. Selects `azurerm_linux_virtual_machine_scale_set`
or `azurerm_windows_virtual_machine_scale_set` based on `os_type` so a single module can back
both operating system families.

## Usage

```hcl
module "vmss" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/compute/vmss?ref=v1.0.0"

  name                 = "app-vmss"
  resource_group_name  = azurerm_resource_group.app.name
  location             = azurerm_resource_group.app.location
  os_type              = "linux"
  sku                  = "Standard_D2s_v5"
  instances            = 3
  admin_username       = "azureuser"
  admin_ssh_public_key = file("~/.ssh/id_rsa.pub")
  subnet_id            = module.subnet.subnet_id

  source_image_reference = {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  enable_autoscale = true

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

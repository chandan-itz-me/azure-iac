# compute/virtual-machine

Creates a Linux or Windows virtual machine with its network interface, optional public IP,
optional additional data disks and extensions. Selects `azurerm_linux_virtual_machine` or
`azurerm_windows_virtual_machine` based on `os_type` so a single module can back both operating
system families.

## Usage

```hcl
module "vm" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/compute/virtual-machine?ref=v1.0.0"

  name                  = "app01"
  resource_group_name   = azurerm_resource_group.app.name
  location              = azurerm_resource_group.app.location
  os_type               = "linux"
  size                  = "Standard_D2s_v5"
  admin_username        = "azureuser"
  admin_ssh_public_key  = file("~/.ssh/id_rsa.pub")
  subnet_id             = module.subnet.subnet_id

  source_image_reference = {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

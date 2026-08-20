# storage/managed-disk

Creates one or more Azure managed disks and, optionally, a disk encryption set backed
by a Key Vault key. Disks default to `Premium_LRS` with network access denied by
default; reference the module's disk encryption set output or bring your own
`disk_encryption_set_id` per disk.

## Usage

```hcl
module "managed_disk" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/storage/managed-disk?ref=v1.0.0"

  name                = "data-disks"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location

  disks = {
    data-01 = {
      disk_size_gb = 128
      zone         = "1"
    }
  }

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

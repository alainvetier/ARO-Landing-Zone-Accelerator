# NOTE: This KV is supporting the VM creation. There are additional KV resources that get created in the supporting stages. These may be consolidated at a later date.

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name = var.kv_name
  location = var.location
  resource_group_name = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled = false

  sku_name = "standard"
  
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Set",
      "List",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_key_vault_secret" "vm_admin_password" {
  name = "vmadminpassword"
  value = var.vm_admin_password
  key_vault_id = azurerm_key_vault.kv.id
}
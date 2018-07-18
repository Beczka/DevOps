locals {
  region_lower = "${lower(var.region)}"
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "kv_resource_group" {
  name     = "${var.resource_group_name}-${local.region_lower}"
  location = "${var.region}"
}

resource "azurerm_key_vault" "kv" {
  name                = "${var.name}-${local.region_lower}"
  location            = "${var.region}"
  resource_group_name = "${azurerm_resource_group.kv_resource_group.name}"

  sku {
    name = "standard"
  }

  tenant_id = "${data.azurerm_client_config.current.tenant_id}"

  access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "${data.azurerm_client_config.current.service_principal_object_id}"

    key_permissions = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey",
    ]

    secret_permissions = [
      "set",
      "restore",
      "recover",
      "purge",
      "list",
      "get",
      "delete",
      "backup",
    ]
  }

  access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "${var.operation_ad_group}"

    key_permissions = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey",
    ]

    secret_permissions = [
      "set",
      "restore",
      "recover",
      "purge",
      "list",
      "get",
      "delete",
      "backup",
    ]
  }

  enabled_for_disk_encryption = true

  tags = "${var.tags}"
}

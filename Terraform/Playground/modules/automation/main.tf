locals {
  region_lower = "${lower(var.region)}"
}

resource "azurerm_resource_group" "automation" {
  name     = "${var.resource_group_name}-${local.region_lower}"
  location = "${var.region}"
  tags     = "${var.tags}"
}

resource "azurerm_automation_account" "account" {
  name                = "${var.name}"
  location            = "${azurerm_resource_group.automation.location}"
  resource_group_name = "${azurerm_resource_group.automation.name}"

  sku {
    name = "Basic"
  }

  tags = "${var.tags}"
}

resource "azurerm_storage_account" "dsc-storage" {
  name                     = "automationdsc"
  resource_group_name      = "${azurerm_resource_group.automation.name}"
  location                 = "${var.region}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = "${var.tags}"
}

resource "azurerm_storage_container" "dsc-container" {
  name                  = "dsc"
  resource_group_name   = "${azurerm_resource_group.automation.name}"
  storage_account_name  = "${azurerm_storage_account.dsc-storage.name}"
  container_access_type = "blob"
}

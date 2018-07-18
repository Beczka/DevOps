locals {
  region_lower = "${lower(var.region)}"
}

resource "azurerm_resource_group" "vnet" {
  name     = "${var.resource_group_name}-${local.region_lower}"
  location = "${var.region}"
  tags     = "${var.tags}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name}"
  location            = "${var.region}"
  resource_group_name = "${azurerm_resource_group.vnet.name}"
  address_space       = ["${var.address_space}"]
  tags                = "${var.tags}"
}

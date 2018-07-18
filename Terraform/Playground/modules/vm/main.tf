locals {
  region_lower = "${lower(var.region)}"
  vm_name      = "terraform-vm"
}

resource "azurerm_resource_group" "vm" {
  name     = "${var.resource_group_name}-${local.region_lower}"
  location = "${var.region}"
  tags     = "${var.tags}"
}

resource "azurerm_public_ip" "vm" {
  count                        = "${var.count}"
  name                         = "vm-ip-${count.index}"
  resource_group_name          = "${azurerm_resource_group.vm.name}"
  public_ip_address_allocation = "dynamic"
  location                     = "${var.region}"
  tags                         = "${var.tags}"
}

resource "azurerm_network_interface" "vm" {
  count               = "${var.count}"
  name                = "vm-nic-${count.index}"
  resource_group_name = "${azurerm_resource_group.vm.name}"
  location            = "${var.region}"
  tags                = "${var.tags}"

  ip_configuration {
    name                          = "default"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.vm.*.id, count.index)}"
  }
}

module "windows-admin" {
  source    = "../kv/create_and_store_secret"
  name      = "testvmadministrator"
  vault_uri = "${var.vault_url}"
}

resource "azurerm_availability_set" "scale-set" {
  name                = "${local.vm_name}-scale-set"
  location            = "${azurerm_resource_group.vm.location}"
  resource_group_name = "${azurerm_resource_group.vm.name}"
  tags                = "${var.tags}"
  managed             = true
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "${local.vm_name}-${count.index}"
  count                 = "${var.count}"
  resource_group_name   = "${azurerm_resource_group.vm.name}"
  location              = "${var.region}"
  network_interface_ids = ["${element(azurerm_network_interface.vm.*.id, count.index)}"]
  vm_size               = "Standard_D2s_v3"
  tags                  = "${var.tags}"
  availability_set_id   = "${var.count == "1" ? "0" : "${azurerm_availability_set.scale-set.id}"}"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "mainos-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "vm-${count.index}"
    admin_username = "testvmadministrator"
    admin_password = "${module.windows-admin.password}"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
}

module "vm-dsc" {
  source                 = "./extensions/dsc/windows"
  count                  = "${var.count}"
  vault_url              = "${var.vault_url}"
  region                 = "${var.region}"
  tags                   = "${var.tags}"
  resource_group_name    = "${azurerm_resource_group.vm.name}"
  virtual_machine_name   = "${local.vm_name}"
  dsc_configuration_name = "AppServer.AppServer"
}

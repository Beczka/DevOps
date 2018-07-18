locals {
  common_tags = "${merge(
        var.common_tags,
        map(
            "Environment", "Test"
        )
    )}"

  resource_prefix = "TEST"
}

module "automation-account" {
  source              = "../../modules/automation"
  region              = "${var.region}"
  tags                = "${local.common_tags}"
  name                = "vm-automation-westeurope"
  resource_group_name = "${local.resource_prefix}-automation"
}

module "kv" {
  source              = "../../modules/kv/create_kv"
  name                = "admin"
  resource_group_name = "${local.resource_prefix}-admin-resources"
  region              = "${var.region}"
  tags                = "${local.common_tags}"
  operation_ad_group  = "9d279d10-48f0-4258-9065-bc43c8441be5"
}

module "vnet" {
  source              = "../../modules/network/vnet"
  name                = "test-vnet"
  address_space       = "${var.address_space}"
  region              = "${var.region}"
  tags                = "${local.common_tags}"
  resource_group_name = "${local.resource_prefix}-vnet"
}

module "common-network-nsg" {
  source = "../../modules/network/nsg/common"
}

module "app-subnet" {
  source               = "../../modules/network/subnet"
  region               = "${var.region}"
  tags                 = "${local.common_tags}"
  name                 = "app-subnet"
  address_prefix       = "${cidrsubnet(var.address_space, 4, 2)}"
  virtual_network_name = "${module.vnet.vnet_name}"
  resource_group_name  = "${module.vnet.vnet_resource_group_name}"

  nsg_rules = [
    "${module.common-network-nsg.nsg_rules["allow_http_rule"]}",
    "${module.common-network-nsg.nsg_rules["allow_https_rule"]}",
    "${module.common-network-nsg.nsg_rules["allow_rdp_rule"]}",
  ]
}

module "test-vm" {
  source              = "../../modules/vm"
  region              = "${var.region}"
  tags                = "${local.common_tags}"
  subnet_id           = "${module.app-subnet.subnet_id}"
  vault_url           = "${module.kv.vault_url}"
  count               = 2
  resource_group_name = "${local.resource_prefix}-vm"
}

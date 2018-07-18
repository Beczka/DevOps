locals {
  registration_url = "https://we-agentservice-prod-1.azure-automation.net/accounts/a263d9ee-258c-4d98-a304-ac7484baf6ba"
}

module "dsc-key" {
  source    = "../../../../kv/get_secret"
  name      = "dsc-registration-key"
  vault_uri = "${var.vault_url}"
}

resource "azurerm_virtual_machine_extension" "vm-dsc" {
  count                      = "${var.count}"
  name                       = "dsc"
  location                   = "${var.region}"
  resource_group_name        = "${var.resource_group_name}"
  virtual_machine_name       = "${var.virtual_machine_name}-${count.index}"
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.72"
  auto_upgrade_minor_version = true
  tags                       = "${var.tags}"

  settings = <<SETTINGS
{
    "wmfVersion": "latest",
    "configuration": {
        "url": "https://automationdsc.blob.core.windows.net/dsc/ConfigurationManager.zip",
        "script": "DscMetaConfig.ps1",
        "function": "DscMetaConfig"
    },
    "configurationArguments": {
        "RegistrationUrl": "${local.registration_url}",        
        "ComputerName": "localhost",
        "NodeConfigurationName": "${var.dsc_configuration_name}"
    }
}
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
{
    "configurationArguments": {
        "RegistrationKey": "${module.dsc-key.secret_value}"
    }
}
PROTECTED_SETTINGS
}

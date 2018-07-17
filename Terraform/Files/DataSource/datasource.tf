# https://www.terraform.io/docs/providers/azurerm/d/key_vault.html

data "azurerm_key_vault" "test" {
  name                = "mykeyvault"
  resource_group_name = "some-resource-group"
}

output "vault_uri" {
  value = "${data.azurerm_key_vault.test.vault_uri}"
}

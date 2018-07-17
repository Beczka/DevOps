resource "azurerm_resource_group" "test" {
  name     = "test-rg-${count.index}"
  location = "West Europe"
  count    = 2
}

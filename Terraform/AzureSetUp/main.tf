# ARM_CLIENT_SECRET => hasło aplikacji z portalu

# client_id    => ApplicationId z portalu
# principal_id => ObjectId z portalu
# tenant_id => Endpoints AD

provider "azurerm" {
  version         = "~> 1.9.0"
  subscription_id = ""
  client_id       = ""
  tenant_id       = ""
}

terraform {
  backend "azurerm" {
    storage_account_name = ""
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    resource_group_name  = "terraform-westeurope"
    arm_subscription_id  = ""
    arm_client_id        = ""
    arm_tenant_id        = ""
  }
}

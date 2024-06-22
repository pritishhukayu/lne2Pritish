provider "azurerm" {
  features {}
}
resource "azurerm_container_registry" "my_acr" {
  name                     = "lne-PritishRG"
  resource_group_name      = azurerm_resource_group.my_rg.name
  location                 = azurerm_resource_group.my_rg.location
  sku                      = "Basic"
  admin_enabled            = true
}

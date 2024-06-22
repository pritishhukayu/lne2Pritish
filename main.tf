provider "azurerm" {
  features {}
}

# Define your resource group
resource "azurerm_resource_group" "my_rg" {
  name     = "lne-PritishRG"
  location = "Central India"
}

# Define your Azure Container Registry
resource "azurerm_container_registry" "my_acr" {
  name                     = "lne2ACR"
  resource_group_name      = azurerm_resource_group.my_rg.name  # Reference the resource group name directly
  location                 = azurerm_resource_group.my_rg.location  # Reference the resource group location directly
  sku                      = "Basic"
  admin_enabled            = true
}

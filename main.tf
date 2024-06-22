resource "azurerm_resource_group" "lne_rg" {
  name     = "lne-rg"
  location = "Central India"
}
 
resource "azurerm_container_registry" "acr" {
  name                = "cubcontainerRegistry1"
  resource_group_name = azurerm_resource_group.lne_rg.name
  location            = azurerm_resource_group.lne_rg.location
  sku                 = "Standard"
  admin_enabled       = true
}
 
resource "azurerm_service_plan" "react_plan" {
  name                = "react-plan"
  resource_group_name = azurerm_resource_group.lne_rg.name
  location            = azurerm_resource_group.lne_rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}
 
resource "azurerm_linux_web_app" "node_app" {
  name                = "lnenodedakshesh"
  resource_group_name = azurerm_resource_group.lne_rg.name
  location            = azurerm_service_plan.react_plan.location
  service_plan_id     = azurerm_service_plan.react_plan.id
 
  site_config {
    application_stack {
      docker_image_name = "cubcontainerregistry1.azurecr.io/lne/node-app:1.0"
    }
  }
}
 
 
resource "azurerm_container_group" "react_app" {
  name                = "lne-react-app"
  location            = azurerm_resource_group.lne_rg.location
  resource_group_name = azurerm_resource_group.lne_rg.name
  ip_address_type     = "Public"
  dns_name_label      = "lnedaksh"
  os_type             = "Linux"
 
  container {
    name   = "react-app"
    image  = "cubcontainerregistry1.azurecr.io/lne/react-app:1.0"
    cpu    = "0.5"
    memory = "1.5"
 
    ports {
      port     = 80
      protocol = "TCP"
    }
 
    environment_variables = {
      API_BASE_URL= "http://testlne.azurewebsites.net"
    }
  }
 
  image_registry_credential {
    server = "cubcontainerregistry1.azurecr.io"
    username = var.username
    password = var.password
  }
}
 
 
resource "azurerm_container_group" "node_app" {
  name                = "lne-node-app"
  location            = azurerm_resource_group.lne_rg.location
  resource_group_name = azurerm_resource_group.lne_rg.name
  ip_address_type     = "Public"
  dns_name_label      = "lnenode"
  os_type             = "Linux"
 
  container {
    name   = "react-app"
    image  = "cubcontainerregistry1.azurecr.io/lne/node-app:1.0"
    cpu    = "1"
    memory = "1.5"
 
    ports {
      port     = 80
      protocol = "TCP"
    }
 
    environment_variables = {
        API_BASE_URL= "http://testlne.azurewebsites.net"
        APPLICATION_HOST= "0.0.0.0"
        APPLICATION_PORT="80"
        DBDIALECT="postgres"
        DBHOST="lnepostgres.postgres.database.azure.com"
        DBNAME="sample-appdb"
        DBPASSWORD="Password#123!"
        DBPORT="5432"
        DBUSERNAME="lnedakshesh"
        NODE_ENV="production"
        WHITELIST_URLS="http://lnedaksh.centralindia.azurecontainer.io"
    }
  }
 
  image_registry_credential {
    server = "cubcontainerregistry1.azurecr.io"
    username = var.username
    password = var.password
  }
}

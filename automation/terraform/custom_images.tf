data "azurerm_resource_group" "client_image" {
  name = "packerFiles"
}

data "azurerm_image" "client_image" {
  name                = "clientImage"
  resource_group_name = "${data.azurerm_resource_group.client_image.name}"
}

data "azurerm_resource_group" "nat_image" {
  name = "packerFiles"
}

data "azurerm_image" "nat_image" {
  name                = "natImage"
  resource_group_name = "${data.azurerm_resource_group.nat_image.name}"
}

data "azurerm_resource_group" "backend_image" {
  name = "packerFiles"
}

data "azurerm_image" "backend_image" {
  name                = "backendImage"
  resource_group_name = "${data.azurerm_resource_group.backend_image.name}"
}

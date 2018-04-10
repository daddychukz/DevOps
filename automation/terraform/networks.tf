# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "terraform_rg" {
  name     = "terraform_rg"
  location = "eastus"

  tags {
    environment = "Development"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "my_vnet" {
  name                = "my_vnet"
  address_space       = ["${var.vnet_address_space}"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.terraform_rg.name}"

  tags {
    environment = "Development"
  }
}

# Create Frontend subnet
resource "azurerm_subnet" "front_end_sub" {
  name                 = "front_end_sub"
  resource_group_name  = "${azurerm_resource_group.terraform_rg.name}"
  virtual_network_name = "${azurerm_virtual_network.my_vnet.name}"
  address_prefix       = "${var.FE_Sub_Address}"
}

# Create Backend subnet
resource "azurerm_subnet" "back_end_sub" {
  name                 = "back_end_sub"
  resource_group_name  = "${azurerm_resource_group.terraform_rg.name}"
  virtual_network_name = "${azurerm_virtual_network.my_vnet.name}"
  address_prefix       = "${var.BE_Sub_Address}"
  route_table_id       = "${azurerm_route_table.BE_route_table.id}"
}

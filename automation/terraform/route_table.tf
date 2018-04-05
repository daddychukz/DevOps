#Create Route table
resource "azurerm_route_table" "terraform_route_table" {
  name                = "terraform_route_table"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.terraform_rg.name}"

  route {
    name                   = "route_to_net"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "192.168.0.5"
  }

  tags {
    environment = "Development"
  }
}

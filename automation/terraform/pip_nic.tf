# Create NAT public IP
resource "azurerm_public_ip" "my_nat_public_ip" {
  name                         = "my_nat_public_ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.terraform_rg.name}"
  public_ip_address_allocation = "static"

  tags {
    environment = "Development"
  }
}

# Create Frontend public IP
resource "azurerm_public_ip" "my_public_ip" {
  name                         = "my_public_ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.terraform_rg.name}"
  public_ip_address_allocation = "static"

  tags {
    environment = "Development"
  }
}

# Create network interface for NAT instance
resource "azurerm_network_interface" "terraform_nat_nic" {
  name                      = "terraform_nat_nic"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.terraform_rg.name}"
  network_security_group_id = "${azurerm_network_security_group.terraform_nat_nsg.id}"
  enable_ip_forwarding      = true

  ip_configuration {
    name                          = "ipconfig_nat_nic"
    subnet_id                     = "${azurerm_subnet.front_end_sub.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.my_nat_public_ip.id}"
  }

  tags {
    environment = "Development"
  }
}

# Create network interface for Frontend instance
resource "azurerm_network_interface" "terraform_public_nic" {
  name                      = "terraform_public_nic"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.terraform_rg.name}"
  network_security_group_id = "${azurerm_network_security_group.terraform_public_nsg.id}"

  ip_configuration {
    name                          = "ipconfig_public_nic"
    subnet_id                     = "${azurerm_subnet.front_end_sub.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.my_public_ip.id}"
  }

  tags {
    environment = "Development"
  }
}

# Create network interface for Backend instance
resource "azurerm_network_interface" "terraform_private_nic" {
  name                      = "terraform_private_nic"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.terraform_rg.name}"
  network_security_group_id = "${azurerm_network_security_group.terraform_private_nsg.id}"

  ip_configuration {
    name                          = "ipconfig_private_nic"
    subnet_id                     = "${azurerm_subnet.back_end_sub.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = ""
  }

  tags {
    environment = "Development"
  }
}

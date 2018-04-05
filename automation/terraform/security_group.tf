# Create Network Security Group and rule
resource "azurerm_network_security_group" "terraform_nat_nsg" {
  name                = "terraform_nat_nsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.terraform_rg.name}"

  security_rule {
    name                       = "SSHRule"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "PrivateToPublicRule"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "0-65535"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  tags {
    environment = "Development"
  }
}

resource "azurerm_network_security_group" "terraform_private_nsg" {
  name                = "terraform_private_nsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.terraform_rg.name}"

  security_rule {
    name                       = "SSHRule"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "192.168.0.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "PostgresRule"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "192.168.0.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "denyAll"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "Development"
  }
}

resource "azurerm_network_security_group" "terraform_public_nsg" {
  name                = "terraform_public_nsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.terraform_rg.name}"

  security_rule {
    name                       = "SSHRule"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPRule"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPSRule"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "Development"
  }
}

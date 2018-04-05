# Create virtual machine for NAT instance
resource "azurerm_virtual_machine" "terraform_nat_vm" {
  name                             = "terraform_nat_vm"
  location                         = "eastus"
  resource_group_name              = "${azurerm_resource_group.terraform_rg.name}"
  network_interface_ids            = ["${azurerm_network_interface.terraform_nat_nic.id}"]
  vm_size                          = "Standard_DS1_v2"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "myOsDisk3"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "terraformNatVM"
    admin_username = "chuks"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/chuks/.ssh/authorized_keys"
      key_data = "${var.nat_ssh}"
    }
  }

  tags {
    environment = "Development"
  }
}

# Create virtual machine for Frontend instance
resource "azurerm_virtual_machine" "terraform_client_vm" {
  name                             = "terraformClientVM"
  location                         = "eastus"
  resource_group_name              = "${azurerm_resource_group.terraform_rg.name}"
  network_interface_ids            = ["${azurerm_network_interface.terraform_public_nic.id}"]
  vm_size                          = "Standard_DS1_v2"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "myOsDisk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "terraformClientVM"
    admin_username = "crystal"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/crystal/.ssh/authorized_keys"
      key_data = "${var.client_ssh}"
    }
  }

  tags {
    environment = "Development"
  }
}

# Create virtual machine for Backend instance
resource "azurerm_virtual_machine" "terraform_backend_vm" {
  name                             = "terraform_backend_vm"
  location                         = "eastus"
  resource_group_name              = "${azurerm_resource_group.terraform_rg.name}"
  network_interface_ids            = ["${azurerm_network_interface.terraform_private_nic.id}"]
  vm_size                          = "Standard_DS1_v2"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "terraformBackendVM"
    admin_username = "${var.backend_username}"
    admin_password = "${var.backend_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "Development"
  }
}

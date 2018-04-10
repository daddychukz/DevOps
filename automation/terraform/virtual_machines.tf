# Create virtual machine for NAT instance
resource "azurerm_virtual_machine" "NAT_VM" {
  name                             = "NAT_VM"
  location                         = "eastus"
  resource_group_name              = "${azurerm_resource_group.terraform_rg.name}"
  network_interface_ids            = ["${azurerm_network_interface.nat_nic.id}"]
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
    computer_name  = "NatVM"
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

  # provisioner "local-exec" {
  #   command = sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
  # }

  provisioner "local-exec" {
    command = "sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE"
  }
}

# Create virtual machine for Frontend instance
resource "azurerm_virtual_machine" "client_vm" {
  name                             = "ClientVM"
  location                         = "eastus"
  resource_group_name              = "${azurerm_resource_group.terraform_rg.name}"
  network_interface_ids            = ["${azurerm_network_interface.public_nic.id}"]
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
resource "azurerm_virtual_machine" "backend_vm" {
  name                             = "backend_vm"
  location                         = "eastus"
  resource_group_name              = "${azurerm_resource_group.terraform_rg.name}"
  network_interface_ids            = ["${azurerm_network_interface.private_nic.id}"]
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
    computer_name  = "BackendVM"
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

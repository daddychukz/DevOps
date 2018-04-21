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
    id = "${data.azurerm_image.nat_image.id}"
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
}

# # Create virtual machine for Frontend instance
# resource "azurerm_virtual_machine" "client_vm" {
#   name                             = "ClientVM"
#   location                         = "eastus"
#   resource_group_name              = "${azurerm_resource_group.terraform_rg.name}"
#   network_interface_ids            = ["${azurerm_network_interface.public_nic.id}"]
#   vm_size                          = "Standard_DS1_v2"
#   delete_os_disk_on_termination    = true
#   delete_data_disks_on_termination = true

#   storage_os_disk {
#     name              = "myOsDisk2"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }

#   storage_image_reference {
#     id = "${data.azurerm_image.client_image.id}"
#   }

#   os_profile {
#     computer_name  = "terraformClientVM"
#     admin_username = "crystal"
#   }

#   os_profile_linux_config {
#     disable_password_authentication = true

#     ssh_keys {
#       path     = "/home/crystal/.ssh/authorized_keys"
#       key_data = "${var.client_ssh}"
#     }
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "cd /var/app/More-Recipes",
#       "pm2 kill",
#       "sudo add-apt-repository -y ppa:certbot/certbot",
#       "sudo apt-get update",
#       "sudo apt-get install python-certbot-nginx -y",
#       "sudo certbot --nginx --non-interactive --test-cert --redirect --agree-tos -d www.chuks-zone.com.ng -m durugo_chuks@yahoo.com",
#       "export NODE_ENV=production",
#       "export configEnvVar=DATABASE_URL",
#       "export DATABASE_URL=${var.DATABASE_URL}",
#       "export SECRET=${var.SECRET}",
#       "sequelize db:migrate",
#       "pm2 start Server/dist/app.js -n chuks",
#     ]

#     connection {
#       type        = "ssh"
#       user        = "crystal"
#       host        = "${azurerm_public_ip.client_public_ip.ip_address}"
#       private_key = "${file("~/.ssh/id_rsa")}"
#     }
#   }

#   tags {
#     environment = "Development"
#   }
# }

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
    id = "${data.azurerm_image.backend_image.id}"
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

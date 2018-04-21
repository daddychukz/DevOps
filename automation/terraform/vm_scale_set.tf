resource "azurerm_virtual_machine_scale_set" "VMScaleSet" {
  name                = "VMScaleSet"
  location            = "${azurerm_resource_group.terraform_rg.location}"
  resource_group_name = "${azurerm_resource_group.terraform_rg.name}"
  upgrade_policy_mode = "Automatic"

  sku {
    name     = "Standard_A0"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    id = "${data.azurerm_image.client_image.id}"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = "terraformClientVM"
    admin_username       = "crystal"
    admin_password       = "${var.backend_password}"
    custom_data          = "${file("~/Documents/cloud-init.txt")}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/crystal/.ssh/authorized_keys"
      key_data = "${var.client_ssh}"
    }
  }

  network_profile {
    name                      = "terraformnetworkprofile"
    primary                   = true
    network_security_group_id = "${azurerm_network_security_group.public_nsg.id}"

    ip_configuration {
      name                                   = "TestIPConfiguration"
      subnet_id                              = "${azurerm_subnet.front_end_sub.id}"
      load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.bpepool.id}"]
      load_balancer_inbound_nat_rules_ids    = ["${element(azurerm_lb_nat_pool.lbnatpool.*.id, count.index)}"]
    }
  }

  #   extension {
  #     name                 = "vmssextension"
  #     publisher            = "Microsoft.Azure.Extensions"
  #     type                 = "CustomScript"
  #     type_handler_version = "2.0"


  #     settings = <<SETTINGS
  #       {
  #           "script": "IyEvYmluL3NoCmFkZC1hcHQtcmVwb3NpdG9yeSAteSBwcGE6Y2VydGJvdC9jZXJ0Ym90CmFwdC1nZXQgdXBkYXRlCmFwdC1nZXQgaW5zdGFsbCBweXRob24tY2VydGJvdC1uZ2lueCAteQpjZXJ0Ym90IC0tbmdpbnggLS1ub24taW50ZXJhY3RpdmUgLS10ZXN0LWNlcnQgLS1yZWRpcmVjdCAtLWFncmVlLXRvcyAtZCB3d3cuY2h1a3Mtem9uZS5jb20ubmcgLW0gZHVydWdvX2NodWtzQHlhaG9vLmNvbQo="
  #       }
  #       SETTINGS
  #   }

  tags {
    environment = "Development"
  }
}

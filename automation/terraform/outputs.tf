output "nat_public_ip" {
  value = "${azurerm_public_ip.nat_public_ip.ip_address}"
}

output "client_public_ip" {
  value = "${azurerm_public_ip.client_public_ip.ip_address}"
}

output "backend_private_ip" {
  value = "${azurerm_network_interface.private_nic.private_ip_address}"
}

output "frontend_private_ip" {
  value = "${azurerm_network_interface.public_nic.private_ip_address}"
}

output "nat_private_ip" {
  value = "${azurerm_network_interface.nat_nic.private_ip_address}"
}

output "backend_name" {
  value = "${azurerm_network_interface.private_nic.name}"
}

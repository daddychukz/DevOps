resource "azurerm_lb" "VMLoadBalancer" {
  name                = "VMLoadBalancer"
  location            = "${azurerm_resource_group.terraform_rg.location}"
  resource_group_name = "${azurerm_resource_group.terraform_rg.name}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.client_public_ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  resource_group_name = "${azurerm_resource_group.terraform_rg.name}"
  loadbalancer_id     = "${azurerm_lb.VMLoadBalancer.id}"
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_nat_pool" "lbnatpool" {
  count                          = 3
  resource_group_name            = "${azurerm_resource_group.terraform_rg.name}"
  name                           = "ssh"
  loadbalancer_id                = "${azurerm_lb.VMLoadBalancer.id}"
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_probe" "vmss" {
  resource_group_name = "${azurerm_resource_group.terraform_rg.name}"
  loadbalancer_id     = "${azurerm_lb.VMLoadBalancer.id}"
  name                = "ssh-running-probe"
  port                = "${var.application_port}"
}

resource "azurerm_lb_rule" "lbnatrule" {
  resource_group_name            = "${azurerm_resource_group.terraform_rg.name}"
  loadbalancer_id                = "${azurerm_lb.VMLoadBalancer.id}"
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = "${var.application_port}"
  backend_port                   = "${var.application_port}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.bpepool.id}"
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = "${azurerm_lb_probe.vmss.id}"
}

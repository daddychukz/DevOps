# Configure the Microsoft Azure Provider
provider "azurerm" {
    subscription_id = "${var.subId}"
    client_id = "${var.clientId}"
    client_secret = "${var.clientSecret}"
    tenant_id = "${var.tenant}"
}
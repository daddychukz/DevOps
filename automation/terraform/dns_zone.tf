resource "azurerm_dns_a_record" "www" {
  name                = "www"
  zone_name           = "${var.domain_name}"
  resource_group_name = "dnsrg"
  ttl                 = 3600
  records             = ["${azurerm_public_ip.client_public_ip.ip_address}"]
}

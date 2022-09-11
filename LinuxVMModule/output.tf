output "vmNameOut" {
  value = azurerm_linux_virtual_machine.DomainControl.name
}
output "vmIDOut" {
  value = azurerm_linux_virtual_machine.DomainControl.id
}
output "pubIPOut"{
  value = azurerm_public_ip.wppubip.ip_address
}
output "domNameOut" {
  value = azurerm_public_ip.wppubip.fqdn
}
output "vmNameOut" {
  value = azurerm_linux_virtual_machine.VTFWPvm.name
}
output "vmIDOut" {
  value = azurerm_linux_virtual_machine.VTFWPvm.id
}
output "domain_name_label" {
  value = data.azurerm_public_ip.wppubip.domain_name_label
}
output "public_ip_address" {
  value = data.azurerm_public_ip.wppubip.ip_address
}
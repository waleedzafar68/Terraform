output "nsg_ids" {
  value = azurerm_network_security_group.nsg[*].id
  }
output "nsgIDs" {
  value = toset(azurerm_network_security_group.nsg[*].id)
}

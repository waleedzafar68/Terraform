output "nsg_ids" {
  value = azurerm_network_security_group.nsg[*].id
  depends_on = [
    azurerm_network_security_group.nsg
  ]
  }

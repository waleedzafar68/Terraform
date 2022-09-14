output "nsg_ids" {
  value = azurerm_network_security_group.nsg[*].id
  }

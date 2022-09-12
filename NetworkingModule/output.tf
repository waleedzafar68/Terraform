output "subnet_ids" {
  value = azurerm_subnet.subList[*].id
}
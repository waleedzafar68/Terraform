#Deploying NSG
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsgName
  location            = var.rscLoc
  resource_group_name = var.rgName
}

resource "azurerm_network_security_rule" "rulesNSG" {
  count                       = var.nsgRulesCount
  name                        = var.rulesNSGNames
  priority                    = var.priorities[count.index]
  direction                   = var.directionRule[(count.index)%(length(var.directionRule))]
  access                      = var.AllowDeny[(count.index)%(length(var.AllowDeny))]
  protocol                    = var.protocols[(count.index)%(length(var.protocols))]
  source_port_range           = var.sourcePorts[(count.index)%(length(var.sourcePorts))]
  destination_port_range      = var.destinationPorts[(count.index)%(length(var.destinationPorts))]
  source_address_prefix       = var.sourcePrefix[(count.index)%(length(var.sourcePrefix))]
  destination_address_prefix  = var.destPrefix[(count.index)%(length(var.destPrefix))]
  resource_group_name         = var.rgName
  network_security_group_name = var.nsgName
  depends_on = [
    azurerm_network_security_group.nsg
  ]
}

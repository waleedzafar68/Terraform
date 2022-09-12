#Deploying Virtual Network
resource "azurerm_virtual_network" "labVnet" {
  name = var.vnetName
  location = var.rscLoc
  address_space = var.vnetAddressSpace
  resource_group_name = var.rgName
  tags = var.tags
}

#Deploying Subnet DMZ
resource "azurerm_subnet" "subList" {
  count = var.subnetCount
  name  = var.subnetNames[count.index] 
  resource_group_name = var.rgName
  virtual_network_name = var.vnetName
  address_prefixes = var.addressPrefixes[count.index]
}
#Deploying NSG
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsgName
  location            = var.rscLoc
  resource_group_name = var.rgName
}

resource "azurerm_network_security_rule" "rulesNSG" {
  count                       = var.nsgRulesCount
  name                        = var.rulesNSGNames[count.index]
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
}


#Attaching Subnet to NSG
resource "azurerm_subnet_network_security_group_association" "nsgDMZsn" {
  subnet_id                 = azurerm_subnet.subList[0].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

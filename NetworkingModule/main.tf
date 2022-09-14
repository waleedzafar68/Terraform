#Deploying Virtual Network
resource "azurerm_virtual_network" "labVnet" {
  name = var.vnetName
  location = var.rscLoc
  address_space = var.vnetAddressSpace
  resource_group_name = var.rgName
  tags = var.tags
}

#Deploying Subnets
resource "azurerm_subnet" "subList" {
  count = var.subnetCount
  name  = var.subnetNames[count.index] 
  resource_group_name = var.rgName
  virtual_network_name = var.vnetName
  address_prefixes = var.addressPrefixes[count.index]
  depends_on = [
    azurerm_virtual_network.labVnet
  ]
}
module "NSGDeply" {
  source = "../NSGModule"
  rgName        = var.rgName
  count         = var.nsgCount
  nsgName       = var.nsgNames[count.index]
  rulesNSGNames = var.rulesNSGNames
  rscLoc        = var.rscLoc
  nsgRulesCount = var.nsgRulesCount[count.index]
  priorities    = var.priorities
  directionRule = var.directionRule
  AllowDeny     = var.AllowDeny
  protocols     = var.protocols
  sourcePorts   = var.sourcePorts
  destinationPorts = var.destinationPorts
  sourcePrefix  = var.sourcePrefix
  destPrefix    = var.destPrefix
}


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
  count         = var.nsgCount
  nsgName       = var.nsgNames[count.index]
  rulesNSGNames = var.rulesNSGNames[(count.index)%length(var.rulesNSGNames)]
  rscLoc        = var.rscLoc
  nsgRulesCount = var.nsgCount[count.index]
  priorities    = var.priorities[(count.index)%length(var.priorities)]
  directionRule = var.directionRule[(count.index)%(length(var.directionRule))]
  AllowDeny     = var.AllowDeny[(count.index)%(length(var.AllowDeny))]
  protocols     = var.protocols[(count.index)%(length(var.protocols))]
  sourcePorts   = var.sourcePorts[(count.index)%(length(var.sourcePorts))]
  dedestinationPorts = var.destinationPorts[(count.index)%(length(var.destinationPorts))]
  sourcePrefix  = var.sourcePrefix[(count.index)%(length(var.sourcePrefix))]
  destPrefix    = var.destPrefix[(count.index)%(length(var.destPrefix))]    
}


#Attaching Subnet to NSG
resource "azurerm_subnet_network_security_group_association" "nsgDMZsn" {
  count = var.nsgCount  
  subnet_id  = azurerm_subnet.subList[count.index].id
  network_security_group_id = module.NSGDeply.nsg_ids[count.index]
  depends_on = [
    module.NSGDeply.nsg_ids[count.index], azurerm_subnet.subList[count.index]
  ]
}

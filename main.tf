provider "azurerm" {  
  features {}
}
resource "azurerm_resource_group" "lab" {
  name     = "LabResourceGroup3"
  location = "eastus"
  tags = {
    "Created by" = "Waleed Zafar"
    "Description" = "Contain all lab resources"
  }
}

#Deploying Virtual Network
resource "azurerm_virtual_network" "labVnet" {
  name = "VTFLabVNet"
  location = "eastus"
  address_space = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.lab.name
  tags = {
    "Created by" = "Waleed Zafar"
    "Description" = "Contain all lab subnets and virtual machines"
  }
}

#Deploying Subnet DMZ
resource "azurerm_subnet" "subDMZ" {
  name = "DMZ"
  resource_group_name = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.labVnet.name
  address_prefixes = ["10.0.1.0/24"]
}
#Deploying NSG
resource "azurerm_network_security_group" "nsg" {
  name                = "VTFLabNSG"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.lab.name
}

resource "azurerm_network_security_rule" "Rule80" {
  name                        = "Web80"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lab.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "Rule443" {
  name                        = "Web443"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lab.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

  resource "azurerm_network_security_rule" "rule22" {
  name                        = "SSH"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lab.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

#Attaching Subnet to NSG
resource "azurerm_subnet_network_security_group_association" "nsgDMZsn" {
  subnet_id                 = azurerm_subnet.subDMZ.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

module "LinuxVMModule" {
  source = "./LinuxVMModule"
  rgName = azurerm_resource_group.lab.name
  rscLoc = azurerm_resource_group.lab.location
  pubIPName = "testPubIP"
  domainLabel = "test1red"
  subnetID = azurerm_subnet.subDMZ.id
  nicConfigName = "Config1"
  nicName = "NIC1"
  script = "IyEgL3Vzci9iaW4vYmFzaApjZCAvCmVjaG8gImNsb25pbmcgZ2l0IgpnaXQgY2xvbmUgImh0dHBzOi8vZ2l0aHViLmNvbS93YWxlZWR6YWZhcjY4L3Z1bG5lcmFibGV3cC5naXQiCmVjaG8gIkNoYW5naW5nIERpcmVjdG9yeSIKY2QgdnVsbmVyYWJsZXdwCnNlZCAtaSAtZSAncy9cciQvLycgaW5zdGFsbC5zaCAjd2FzIGEgcHJvYmxlbSB3aXRoIGNhcnJpYWdlIHJldHVybgpiYXNoIGluc3RhbGwuc2gg"
  osDiskName = "osDisk1"
  adminPassword = "Viper@RedTeam1"
  adminUserName = "Viper1"
  compName = "Viper"
  vmName = "Viper1"
}

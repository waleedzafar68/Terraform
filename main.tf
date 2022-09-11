provider "azurerm" {  
  features {}
}
resource "azurerm_resource_group" "lab" {
  name     = var.rgName
  location = var.rscLoc
  tags = {
    "Created by" = "Waleed Zafar"
    "Description" = "Contain all lab resources"
  }
}

#Deploying Virtual Network
resource "azurerm_virtual_network" "labVnet" {
  name = var.rgName
  location = var.rscLoc
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
  location            = var.rscLoc
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
 resource "azurerm_network_security_rule" "RDP" {
  name                        = "RDP"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
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

/*module "LinuxVMModule" {
  source = "./LinuxVMModule"
  rgName = azurerm_resource_group.lab.name
  rscLoc = azurerm_resource_group.lab.location
  pubIPName = "testPubIP"
  domainLabel = "test1red"
  subnetID = azurerm_subnet.subDMZ.id
  nicConfigName = "Config1"
  nicName = "NIC1"
  script1 = "IyEgL3Vzci9iaW4vYmFzaApjZCAvCmVjaG8gImNsb25pbmcgZ2l0IgpnaXQgY2xvbmUgImh0dHBzOi8vZ2l0aHViLmNvbS93YWxlZWR6YWZhcjY4L3Z1bG5lcmFibGV3cC5naXQiCmVjaG8gIkNoYW5naW5nIERpcmVjdG9yeSIKY2QgdnVsbmVyYWJsZXdwCnNlZCAtaSAtZSAncy9cciQvLycgaW5zdGFsbC5zaCAjd2FzIGEgcHJvYmxlbSB3aXRoIGNhcnJpYWdlIHJldHVybgpiYXNoIGluc3RhbGwuc2gg"
  osDiskName = "osDisk1"
  adminPassword = var.adminPass
  adminUserName = "Viper1"
  compName = "Viper"
  vmName = "Viper1"
}*/
module "WindowsServerModule" {
  source = "./WindowsServerModule"
  rgName = azurerm_resource_group.lab.name
  rscLoc = azurerm_resource_group.lab.location
  pubIPName = "testPubIP"
  domainLabel = "test1red"
  subnetID = azurerm_subnet.subDMZ.id
  nicConfigName = "Config1"
  nicName = "NIC1"
  script1 = "IwBEAGUAYwBsAGEAcgBlACAAdgBhAHIAaQBhAGIAbABlAHMACgAkAEQAYQB0AGEAYgBhAHMAZQBQAGEAdABoACAAPQAgACIAYwA6AFwAdwBpAG4AZABvAHcAcwBcAE4AVABEAFMAIgAKACQARABvAG0AYQBpAG4ATQBvAGQAZQAgAD0AIAAiAFcAaQBuAFQAaAByAGUAcwBoAG8AbABkACIACgAkAEQAbwBtAGEAaQBuAE4AYQBtAGUAIAA9ACAAIgB2AHQAZgAuAHIAZQBkAHQAZQBhAG0ALgBjAG8AbQAiAAoAJABEAG8AbQBhAG4AaQBuAE4AZQB0AEIASQBPAFMATgBhAG0AZQAgAD0AIAAiAFYAVABGACIACgAkAEYAbwByAGUAcwB0AE0AbwBkAGUAIAA9ACAAIgBXAGkAbgBUAGgAcgBlAHMAaABvAGwAZAAiAAoAJABMAG8AZwBQAGEAdABoACAAPQAgACIAYwA6AFwAdwBpAG4AZABvAHcAcwBcAE4AVABEAFMAIgAKACQAUwB5AHMAVgBvAGwAUABhAHQAaAAgAD0AIAAiAGMAOgBcAHcAaQBuAGQAbwB3AHMAXABTAFkAUwBWAE8ATAAiAAoAJABmAGUAYQB0AHUAcgBlAEwAbwBnAFAAYQB0AGgAIAA9ACAAIgBjADoAXABmAGUAYQB0AHUAcgBlAGwAbwBnAC4AdAB4AHQAIgAgAAoAJABQAGEAcwBzAHcAbwByAGQAIAA9ACAAIgBkAGMAcABhAHMAcwB3AG8AcgBkAEAAVgBUAEYAMQAiAAoAJABTAGUAYwB1AHIAZQBTAHQAcgBpAG4AZwAgAD0AIABDAG8AbgB2AGUAcgB0AFQAbwAtAFMAZQBjAHUAcgBlAFMAdAByAGkAbgBnACAAJABQAGEAcwBzAHcAbwByAGQAIAAtAEEAcwBQAGwAYQBpAG4AVABlAHgAdAAgAC0ARgBvAHIAYwBlAAoACgAjAEkAbgBzAHQAYQBsAGwAIABBAEQAIABEAFMALAAgAEQATgBTACAAYQBuAGQAIABHAFAATQBDACAACgBzAHQAYQByAHQALQBqAG8AYgAgAC0ATgBhAG0AZQAgAGEAZABkAEYAZQBhAHQAdQByAGUAIAAtAFMAYwByAGkAcAB0AEIAbABvAGMAawAgAHsAIAAKAEEAZABkAC0AVwBpAG4AZABvAHcAcwBGAGUAYQB0AHUAcgBlACAALQBOAGEAbQBlACAAIgBhAGQALQBkAG8AbQBhAGkAbgAtAHMAZQByAHYAaQBjAGUAcwAiACAALQBJAG4AYwBsAHUAZABlAEEAbABsAFMAdQBiAEYAZQBhAHQAdQByAGUAIAAtAEkAbgBjAGwAdQBkAGUATQBhAG4AYQBnAGUAbQBlAG4AdABUAG8AbwBsAHMAIAAKAEEAZABkAC0AVwBpAG4AZABvAHcAcwBGAGUAYQB0AHUAcgBlACAALQBOAGEAbQBlACAAIgBkAG4AcwAiACAALQBJAG4AYwBsAHUAZABlAEEAbABsAFMAdQBiAEYAZQBhAHQAdQByAGUAIAAtAEkAbgBjAGwAdQBkAGUATQBhAG4AYQBnAGUAbQBlAG4AdABUAG8AbwBsAHMAIAAKAEEAZABkAC0AVwBpAG4AZABvAHcAcwBGAGUAYQB0AHUAcgBlACAALQBOAGEAbQBlACAAIgBnAHAAbQBjACIAIAAtAEkAbgBjAGwAdQBkAGUAQQBsAGwAUwB1AGIARgBlAGEAdAB1AHIAZQAgAC0ASQBuAGMAbAB1AGQAZQBNAGEAbgBhAGcAZQBtAGUAbgB0AFQAbwBvAGwAcwAgAH0AIAAKAFcAYQBpAHQALQBKAG8AYgAgAC0ATgBhAG0AZQAgAGEAZABkAEYAZQBhAHQAdQByAGUAIAAKAEcAZQB0AC0AVwBpAG4AZABvAHcAcwBGAGUAYQB0AHUAcgBlACAAfAAgAFcAaABlAHIAZQAgAGkAbgBzAHQAYQBsAGwAZQBkACAAPgA+ACQAZgBlAGEAdAB1AHIAZQBMAG8AZwBQAGEAdABoAAoACgAjAEMAcgBlAGEAdABlACAATgBlAHcAIABBAEQAIABGAG8AcgBlAHMAdAAKAEkAbgBzAHQAYQBsAGwALQBBAEQARABTAEYAbwByAGUAcwB0ACAALQBDAHIAZQBhAHQAZQBEAG4AcwBEAGUAbABlAGcAYQB0AGkAbwBuADoAJABmAGEAbABzAGUAIAAtAEQAYQB0AGEAYgBhAHMAZQBQAGEAdABoACAAJABEAGEAdABhAGIAYQBzAGUAUABhAHQAaAAgAC0ARABvAG0AYQBpAG4ATQBvAGQAZQAgACQARABvAG0AYQBpAG4ATQBvAGQAZQAgAC0ARABvAG0AYQBpAG4ATgBhAG0AZQAgACQARABvAG0AYQBpAG4ATgBhAG0AZQAgAC0AUwBhAGYAZQBNAG8AZABlAEEAZABtAGkAbgBpAHMAdAByAGEAdABvAHIAUABhAHMAcwB3AG8AcgBkACAAJABTAGUAYwB1AHIAZQBTAHQAcgBpAG4AZwAgAC0ARABvAG0AYQBpAG4ATgBlAHQAYgBpAG8AcwBOAGEAbQBlACAAJABEAG8AbQBhAGkAbgBOAGUAdABCAEkATwBTAE4AYQBtAGUAIAAtAEYAbwByAGUAcwB0AE0AbwBkAGUAIAAkAEYAbwByAGUAcwB0AE0AbwBkAGUAIAAtAEkAbgBzAHQAYQBsAGwARABuAHMAOgAkAHQAcgB1AGUAIAAtAEwAbwBnAFAAYQB0AGgAIAAkAEwAbwBnAFAAYQB0AGgAIAAtAE4AbwBSAGUAYgBvAG8AdABPAG4AQwBvAG0AcABsAGUAdABpAG8AbgA6ACQAZgBhAGwAcwBlACAALQBTAHkAcwB2AG8AbABQAGEAdABoACAAJABTAHkAcwBWAG8AbABQAGEAdABoACAALQBGAG8AcgBjAGUAOgAkAHQAcgB1AGUA"
  osDiskName = "osDisk1"
  adminPassword = var.adminPass
  adminUserName = "Viper1"
  compName = "Viper"
  vmName = "Viper1"
}
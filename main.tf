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

module "Networking" {
  source = "./NetworkingModule"
  rgName = azurerm_resource_group.lab.name
  rscLoc = azurerm_resource_group.lab.location
  vnetName = "VNetLab"
  subnetCount = 3
  nsgCount = 2
  subnetNames = ["subDMZ","subServer","subUser"]
  addressPrefixes = [["10.0.1.0/24"],["10.0.2.0/24"],["10.0.3.0/24"]]
  nsgNames = ["NSGforAll", "NSGServer"]
  nsgRulesCount =[4,2]
  rulesNSGNames = ["Rule22","Rule3389", "Rule443","Rule80"]
  priorities = ["1001","1002","1003","1004"]
  destinationPorts = ["443","80","22","3389"]
}
#Attaching Subnet to NSG

module "LinuxVMModule" {
  source = "./LinuxVMModule"
  rgName = azurerm_resource_group.lab.name
  rscLoc = azurerm_resource_group.lab.location
  pubIPName = "testPubIP"
  domainLabel = "test1red"
  subnetID = module.Networking.subnet_ids[0]
  nicConfigName = "Config1"
  nicName = "NIC1"
  script1 = "IyEgL3Vzci9iaW4vYmFzaApjZCAvCmVjaG8gImNsb25pbmcgZ2l0IgpnaXQgY2xvbmUgImh0dHBzOi8vZ2l0aHViLmNvbS93YWxlZWR6YWZhcjY4L3Z1bG5lcmFibGV3cC5naXQiCmVjaG8gIkNoYW5naW5nIERpcmVjdG9yeSIKY2QgdnVsbmVyYWJsZXdwCnNlZCAtaSAtZSAncy9cciQvLycgaW5zdGFsbC5zaCAjd2FzIGEgcHJvYmxlbSB3aXRoIGNhcnJpYWdlIHJldHVybgpiYXNoIGluc3RhbGwuc2gg"
  osDiskName = "osDisk1"
  adminPassword = var.adminPass
  adminUserName = "Viper1"
  compName = "Viper"
  vmName = "Viper1"
}
module "WindowsServerModule" {
  source = "./WindowsVMModule"
  rgName = azurerm_resource_group.lab.name
  rscLoc = azurerm_resource_group.lab.location
  pubIPName = "test2PubIP"
  domainLabel = "test2red"
  subnetID = module.Networking.subnet_ids[0]
  nicConfigName = "Config2"
  nicName = "NIC2"
  script1 = "IwBEAGUAYwBsAGEAcgBlACAAdgBhAHIAaQBhAGIAbABlAHMACgAkAEQAYQB0AGEAYgBhAHMAZQBQAGEAdABoACAAPQAgACIAYwA6AFwAdwBpAG4AZABvAHcAcwBcAE4AVABEAFMAIgAKACQARABvAG0AYQBpAG4ATQBvAGQAZQAgAD0AIAAiAFcAaQBuAFQAaAByAGUAcwBoAG8AbABkACIACgAkAEQAbwBtAGEAaQBuAE4AYQBtAGUAIAA9ACAAIgB2AHQAZgAuAHIAZQBkAHQAZQBhAG0ALgBjAG8AbQAiAAoAJABEAG8AbQBhAG4AaQBuAE4AZQB0AEIASQBPAFMATgBhAG0AZQAgAD0AIAAiAFYAVABGACIACgAkAEYAbwByAGUAcwB0AE0AbwBkAGUAIAA9ACAAIgBXAGkAbgBUAGgAcgBlAHMAaABvAGwAZAAiAAoAJABMAG8AZwBQAGEAdABoACAAPQAgACIAYwA6AFwAdwBpAG4AZABvAHcAcwBcAE4AVABEAFMAIgAKACQAUwB5AHMAVgBvAGwAUABhAHQAaAAgAD0AIAAiAGMAOgBcAHcAaQBuAGQAbwB3AHMAXABTAFkAUwBWAE8ATAAiAAoAJABmAGUAYQB0AHUAcgBlAEwAbwBnAFAAYQB0AGgAIAA9ACAAIgBjADoAXABmAGUAYQB0AHUAcgBlAGwAbwBnAC4AdAB4AHQAIgAgAAoAJABQAGEAcwBzAHcAbwByAGQAIAA9ACAAIgBkAGMAcABhAHMAcwB3AG8AcgBkAEAAVgBUAEYAMQAiAAoAJABTAGUAYwB1AHIAZQBTAHQAcgBpAG4AZwAgAD0AIABDAG8AbgB2AGUAcgB0AFQAbwAtAFMAZQBjAHUAcgBlAFMAdAByAGkAbgBnACAAJABQAGEAcwBzAHcAbwByAGQAIAAtAEEAcwBQAGwAYQBpAG4AVABlAHgAdAAgAC0ARgBvAHIAYwBlAAoACgAjAEkAbgBzAHQAYQBsAGwAIABBAEQAIABEAFMALAAgAEQATgBTACAAYQBuAGQAIABHAFAATQBDACAACgBzAHQAYQByAHQALQBqAG8AYgAgAC0ATgBhAG0AZQAgAGEAZABkAEYAZQBhAHQAdQByAGUAIAAtAFMAYwByAGkAcAB0AEIAbABvAGMAawAgAHsAIAAKAEEAZABkAC0AVwBpAG4AZABvAHcAcwBGAGUAYQB0AHUAcgBlACAALQBOAGEAbQBlACAAIgBhAGQALQBkAG8AbQBhAGkAbgAtAHMAZQByAHYAaQBjAGUAcwAiACAALQBJAG4AYwBsAHUAZABlAEEAbABsAFMAdQBiAEYAZQBhAHQAdQByAGUAIAAtAEkAbgBjAGwAdQBkAGUATQBhAG4AYQBnAGUAbQBlAG4AdABUAG8AbwBsAHMAIAAKAEEAZABkAC0AVwBpAG4AZABvAHcAcwBGAGUAYQB0AHUAcgBlACAALQBOAGEAbQBlACAAIgBkAG4AcwAiACAALQBJAG4AYwBsAHUAZABlAEEAbABsAFMAdQBiAEYAZQBhAHQAdQByAGUAIAAtAEkAbgBjAGwAdQBkAGUATQBhAG4AYQBnAGUAbQBlAG4AdABUAG8AbwBsAHMAIAAKAEEAZABkAC0AVwBpAG4AZABvAHcAcwBGAGUAYQB0AHUAcgBlACAALQBOAGEAbQBlACAAIgBnAHAAbQBjACIAIAAtAEkAbgBjAGwAdQBkAGUAQQBsAGwAUwB1AGIARgBlAGEAdAB1AHIAZQAgAC0ASQBuAGMAbAB1AGQAZQBNAGEAbgBhAGcAZQBtAGUAbgB0AFQAbwBvAGwAcwAgAH0AIAAKAFcAYQBpAHQALQBKAG8AYgAgAC0ATgBhAG0AZQAgAGEAZABkAEYAZQBhAHQAdQByAGUAIAAKAEcAZQB0AC0AVwBpAG4AZABvAHcAcwBGAGUAYQB0AHUAcgBlACAAfAAgAFcAaABlAHIAZQAgAGkAbgBzAHQAYQBsAGwAZQBkACAAPgA+ACQAZgBlAGEAdAB1AHIAZQBMAG8AZwBQAGEAdABoAAoACgAjAEMAcgBlAGEAdABlACAATgBlAHcAIABBAEQAIABGAG8AcgBlAHMAdAAKAEkAbgBzAHQAYQBsAGwALQBBAEQARABTAEYAbwByAGUAcwB0ACAALQBDAHIAZQBhAHQAZQBEAG4AcwBEAGUAbABlAGcAYQB0AGkAbwBuADoAJABmAGEAbABzAGUAIAAtAEQAYQB0AGEAYgBhAHMAZQBQAGEAdABoACAAJABEAGEAdABhAGIAYQBzAGUAUABhAHQAaAAgAC0ARABvAG0AYQBpAG4ATQBvAGQAZQAgACQARABvAG0AYQBpAG4ATQBvAGQAZQAgAC0ARABvAG0AYQBpAG4ATgBhAG0AZQAgACQARABvAG0AYQBpAG4ATgBhAG0AZQAgAC0AUwBhAGYAZQBNAG8AZABlAEEAZABtAGkAbgBpAHMAdAByAGEAdABvAHIAUABhAHMAcwB3AG8AcgBkACAAJABTAGUAYwB1AHIAZQBTAHQAcgBpAG4AZwAgAC0ARABvAG0AYQBpAG4ATgBlAHQAYgBpAG8AcwBOAGEAbQBlACAAJABEAG8AbQBhAGkAbgBOAGUAdABCAEkATwBTAE4AYQBtAGUAIAAtAEYAbwByAGUAcwB0AE0AbwBkAGUAIAAkAEYAbwByAGUAcwB0AE0AbwBkAGUAIAAtAEkAbgBzAHQAYQBsAGwARABuAHMAOgAkAHQAcgB1AGUAIAAtAEwAbwBnAFAAYQB0AGgAIAAkAEwAbwBnAFAAYQB0AGgAIAAtAE4AbwBSAGUAYgBvAG8AdABPAG4AQwBvAG0AcABsAGUAdABpAG8AbgA6ACQAZgBhAGwAcwBlACAALQBTAHkAcwB2AG8AbABQAGEAdABoACAAJABTAHkAcwBWAG8AbABQAGEAdABoACAALQBGAG8AcgBjAGUAOgAkAHQAcgB1AGUA"
  osDiskName = "osDisk2"
  adminPassword = var.adminPass
  adminUserName = "Viper1"
  compName = "Viper2"
  vmName = "Viper2"
}

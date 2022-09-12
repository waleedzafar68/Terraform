variable "vnetName" {
    description = "Name of the virtual Network"
}
variable "vnetAddressSpace" {
    description = "Address Space for the virtual Network"
    type = list(string)
    default = ["10.0.0.0/16"]
}
variable "subnetCount" {
    description = "Number of Subnets you want to create in the VNet"
    type = number
}
variable "nsgRulesCount" {
    description = "Number of Rules you want to create in the NSG"
    type = number  
}
variable "rgName" {
    description = "Name of the Resource Group that will contain all the resources for the lab"
}
variable "rscLoc" {
  description = "Location of the deployment of resources"
}
variable "tags" {
  description = "Tags for resources"
  type = map(string)
  default = {
    "Created by" = "Waleed Zafar"
    }
}
variable "subnetNames" {
  description = "List of subnet Names"
  type = list(string)
  default = []
}
variable "addressPrefixes" {
    description = "List of lists of address prefixes for the subnets"
    default = [[]]  
    type = list(list(string))
}
variable "nsgName" {
    description = "Name of the NSG"
    type = string
}
variable "rulesNSGNames" {
   type = list(string)
}
variable "directionRule" {
  type = list(string)
}
variable "priorities" {
  type = list(string)
}
variable "AllowDeny" {
  type = list(string)
}
variable "protocols" {
    type = list(string)
}
variable "sourcePorts" {
    type = list(string)
}
variable "destinationPorts" {
  type = list(string)
}
variable "sourcePrefix" {
    type = list(string)
}
variable "destPrefix" {
    type = list(string)
}


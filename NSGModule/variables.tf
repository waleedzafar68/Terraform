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
variable "subnetID" {
   description = "ID of the subnet NSG will be attached to"
}
variable "nsgRulesCount" {
    description = "Number of Rules you want to create in the NSG"
    type = number  
}

variable "nsgName" {
    description = "Name of the NSG"
    type = string
}
variable "rulesNSGNames" {
   description = "Name of the rules. List should be equal to count variable in length" 
   type = list(string)
}
variable "directionRule" {
  description = "List stating Direction of rules. Is a cyclic list. Index starts from 0 if length of list != count"  
  type = list(string)
  default = ["Inbound"]
}
variable "priorities" {
  description = "List of priorities. List should be equal to count variable in length"   
  type = list(string)
}
variable "AllowDeny" {
  description = "List stating Action (Allow or Deny) of rules. Is a cyclic list. Index starts from 0 if length of list != count"    
  type = list(string)
  default = ["Allow"]
}
variable "protocols" {
    description = "List stating protocols of rules. Is a cyclic list. Index starts from 0 if length of list != count"  
    type = list(string)
    default = ["Tcp"]
}
variable "sourcePorts" {
    description = "List stating source ports of rules. Is a cyclic list. Index starts from 0 if length of list != count"  
    type = list(string)
    default = ["*"]
}
variable "destinationPorts" {
  description = "List stating destination ports of rules. Is a cyclic list. Index starts from 0 if length of list != count"   
  type = list(string)
}
variable "sourcePrefix" {
    description = "List stating Source Prefixes of rules. Is a cyclic list. Index starts from 0 if length of list != count"      
    type = list(string)
    default = ["*"]
}
variable "destPrefix" {
    description = "List stating Destination Prefixes of rules. Is a cyclic list. Index starts from 0 if length of list != count"  
    type = list(string)
    default = ["*"]
}
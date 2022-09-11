variable "rgName" {
    description = "Name of the Resource Group that will contain all the resources for the lab"
}
variable "rscLoc" {
  description = "Location of the deployment of resources"
}
variable "pubIPName"{
    description = "Name of the public IP for the VM"
}
variable "domainLabel" {
  description = "Domain Name for the public IP for the VM"
}
variable "allocationMethod" {
  description = "Allocation Method of the public IP"
  default = "Dynamic"
}
variable "nicConfigName" {
  description = "Name for the NIC configuration"
}
variable "subnetID" {
  description = "NIC's Subnet or VMs Subnet"
}
variable "privAllocationMethod" {
  description = "Allocation Method of the private IP"
  default = "Dynamic"
}

variable "nicName" {
    description = "Name of the NIC for the VM"
}
variable "vmName" {
  description = "Virtual Machine Name"
}
variable "vmSize" {
    description = "Virtual Machine Size"
    default = "Standard_B1s"
}
variable "osDiskName" {
  description = "OS Disk Name"
}
variable "osDiskType" {
  description = "OS Disk Type"
  default = "Premium_LRS"
}
variable "sourceImage" {
    type = list(object({
        offer = string
        publisher = string
        sku = string
        version = string
    }))
    default = [ {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2022-Datacenter"
        version   = "latest"
    } ]
  
}
variable "compName" {
  description = "Computer Name of the Virtual Machine"
}
variable "adminUserName" {
  description = "Admin Username for the Virtual Machine"
}
variable "adminPassword" {
  description = "Admin Password for the Virtual Machine"
  sensitive = true
}
variable "scriptName" {
    description = "Name of the Script to run on the Virtual Machine"
    default = "StartupScript"
}
variable "script1" {
    description = "Will contain the encoded script to run"
}
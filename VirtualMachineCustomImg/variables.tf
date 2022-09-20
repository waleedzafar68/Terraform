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
    default = "Standard_B2s"
}
variable "osDiskName" {
  description = "OS Disk Name"
}
variable "osDiskType" {
  description = "OS Disk Type"
  default = "Premium_LRS"
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
variable "script1" {
    description = "Will contain the encoded script to run"
}
variable "imgName" {
  description = "Name of custom image"
  default = "Image1"
}
variable "OSType" {
  description = "Type of OS (Linux or Windows)"
  default = "Linux"
}
variable "vhdUri" {
  description = "URL of the VHD"
  default = "https://terraformprac2.blob.core.windows.net/imgcontainer/torment-improved-disk1.vhd"
}
variable "createOption" {
  description = "How to create Disk"
  default = "FromImage"
}
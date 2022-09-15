variable "rgName" {
    description = "Name of the Resource Group that will contain all the resources for the lab"
}
variable "rscLoc" {
  description = "Location of the deployment of resources"
}
variable "adminPass" {
  description = "It is admin password. Set it always using -var 'adminPass = <Password>'"
  sensitive = true
}
variable "LinuxVMCount" {
  description = "Number of machines to be Provisioned (Linux)"
  type = number
}
variable "LinuxMachineNames" {
  description = "Name of the Linux Machines"
  type = list(string)
}
variable "pubIPNamesLinux" {
  description = "Name of the associated Public IPs (Linux VMs)"
}
variable "domainLabelsLinux" {
  description = "Name of the domain Names of Linux VMs"
  type = list(string)
}
variable "subNetIDs" {
  description = "IDs of the subnets these Linux machines will be provisioned in"
  type = list(string)
}
variable "nicConfigNames" {
  description = "Name of the NIC configs (Linux VMs)"
  type = list(string)
}
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
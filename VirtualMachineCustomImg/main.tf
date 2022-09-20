

resource "azurerm_public_ip" "wppubip" {
  name                = var.pubIPName
  resource_group_name = var.rgName
  location            = var.rscLoc
  allocation_method   = var.allocationMethod
  domain_name_label   = var.domainLabel

  tags = {
    environment = "Wordpress VM public IP"
  }
}

#Deploy NIC for VM Wordpress
# Create network interface
resource "azurerm_network_interface" "wpNIC" {
  name                = var.nicName
  location            = var.rscLoc
  resource_group_name = var.rgName 
  ip_configuration {
    name                          = var.nicConfigName
    subnet_id                     = var.subnetID
    private_ip_address_allocation = var.privAllocationMethod
    public_ip_address_id          = azurerm_public_ip.wppubip.id
  }
  tags ={
    "Description" = "NIC to be attached to Vulnerable Wordpress VM"
  }
}


#Create Wordpress VM
# Create virtual machine
resource "azurerm_virtual_machine" "customVM" {
  name                  = var.vmName
  location              = var.rscLoc
  resource_group_name   = var.rgName
  network_interface_ids = [azurerm_network_interface.wpNIC.id]
  vm_size               = var.vmSize

  storage_os_disk {
    name          = var.osDiskName
    caching       = "ReadWrite"
    create_option = var.createOption
    managed_disk_type = var.osDiskType
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  os_profile {
  computer_name       = var.compName
  admin_password = var.adminPassword
  custom_data = var.script1
  admin_username   = var.adminUserName
  
  }
  }

resource "azurerm_image" "customImage" {
  name                = var.imgName
  location            = var.rscLoc
  resource_group_name = var.rgName

  os_disk {
    os_type  = var.OSType
    os_state = "Generalized"
    blob_uri = var.vhdUri
  }
}

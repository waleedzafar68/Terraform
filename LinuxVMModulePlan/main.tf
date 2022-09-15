

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
resource "azurerm_linux_virtual_machine" "VTFWPvm" {
  name                  = var.vmName
  location              = var.rscLoc
  resource_group_name   = var.rgName
  network_interface_ids = [azurerm_network_interface.wpNIC.id]
  size                  = var.vmSize
  allow_extension_operations = true

  os_disk {
    name                 = var.osDiskName
    caching              = "ReadWrite"
    storage_account_type = var.osDiskType
  }

  source_image_reference {
    offer                 = var.sourceImage[0].offer
    publisher             = var.sourceImage[0].publisher
    sku                   = var.sourceImage[0].sku
    version               = var.sourceImage[0].version
  }

  plan {
    name = var.plan.name
    publisher = var.plan.publisher
    product = var.plan.product
  }

  computer_name                   = var.compName
  admin_username                  = var.adminUserName
  disable_password_authentication = false
  admin_password = var.adminPassword
  custom_data = var.script1
}
resource "azurerm_marketplace_agreement" "LinuxVMagreement" {
    publisher = var.plan.publisher
    offer     = var.plan.offer
    plan      = var.plan.name
   }

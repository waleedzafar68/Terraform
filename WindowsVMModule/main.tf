#Deploying Public IP for Windows Server VM
resource "azurerm_public_ip" "wppubip" {
  name                = var.pubIPName
  resource_group_name = var.rgName
  location            = var.rscLoc
  allocation_method   = var.allocationMethod
  domain_name_label   = var.domainLabel

  tags = {
    environment = "DC VM public IP"
  }
}

# Create network interface
resource "azurerm_network_interface" "wpNIC" {
  name                = var.nicName
  location            = var.rscLoc
  resource_group_name = var.rgName

  ip_configuration {
    name                          = var.nicConfigName
    subnet_id                     = var.subnetID
    private_ip_address_allocation = var.privAllocationMethod
    private_ip_address            = var.privateIP
    public_ip_address_id          = azurerm_public_ip.wppubip.id
  }
  tags ={
    "Description" = "NIC to be attached to Vulnerable Wordpress VM"
  }
}

resource "azurerm_windows_virtual_machine" "DomainControl" {
  name                  = var.vmName
  location              = var.rscLoc
  resource_group_name   = var.rgName
  size                  = var.vmSize
  network_interface_ids = [azurerm_network_interface.wpNIC.id]
  
  computer_name  = var.compName
  admin_username = var.adminUserName
  admin_password = var.adminPassword
  os_disk {
    name                 = var.osDiskName
    caching              = "ReadWrite"
    storage_account_type = var.osDiskType
  }
  source_image_reference {
    publisher = var.sourceImage[0].publisher
    offer     = var.sourceImage[0].offer
    sku       = var.sourceImage[0].sku
    version   = var.sourceImage[0].version
  }
  provision_vm_agent       = true
}

resource "azurerm_virtual_machine_extension" "vmext" {
  name                 = var.scriptName
  virtual_machine_id   = azurerm_windows_virtual_machine.DomainControl.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  
  settings = <<SETTINGS
    {
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted -EncodedCommand ${var.script1}"
    }
SETTINGS

}

provider "azurerm" {
    features{

    }
  tenant_id       = ""    # Use your own tenant_id, ...
  subscription_id = ""    # ... subscription_id, ...

  client_id       = ""    # ... client_id and ...
  client_secret   = ""     
}


data "azurerm_resource_group" "rg" {
  name     = var.resourceGroupName
}

data "azurerm_virtual_network" "virtualnetwork" {
  name                = var.virtualNetworkName
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnetName
  virtual_network_name = data.azurerm_virtual_network.virtualnetwork.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}


resource "azurerm_network_interface" "nic" {
  name                = var.NetworInterfeceController
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "VM" {
  name                = var.VMName
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  availability_set_id = azurerm_availability_set.avset.id
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_availability_set" "avset" {
  name                = "avset"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  tags = {
    environment = "Dev"
  }
}


provider "azurerm" {
    features{

    }
  tenant_id       = "56f9bee4-d4f1-4551-9e9b-8d9a7bf1d004"    # Use your own tenant_id, ...
  subscription_id = "b5e05303-a7cb-41ce-a1ac-6c8420a44235"    # ... subscription_id, ...

  client_id       = "1f8a04bb-cf4d-41fb-9402-730d87cba28a"    # ... client_id and ...
  client_secret   = "Gu7-7x6jaE_FCwgZs4_CezND_3R~kXFiCO"     
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
  name                = "nic"
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


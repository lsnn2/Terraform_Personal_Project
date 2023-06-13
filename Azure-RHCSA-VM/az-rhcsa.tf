provider "azurerm" {
  features {}
}

variable "pubid" {
  type        = string
}

resource "azurerm_resource_group" "test" {
  name     = "rhcsa-resource-group"
  location = "eastus"
}

# Create a virtual network
resource "azurerm_virtual_network" "test" {
  name                = "rhcsa-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

# Create a subnet
resource "azurerm_subnet" "test" {
  name                 = "test-subnet"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes       = ["10.0.1.0/24"]
}

# Create a public IP address
resource "azurerm_public_ip" "test" {
  name                = "test-public-ip"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  allocation_method   = "Static"
}

# Create a network interface
resource "azurerm_network_interface" "test" {
  name                = "test-nic"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  ip_configuration {
    name                          = "test-ip-config"
    subnet_id                     = azurerm_subnet.test.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.test.id
  }
}

# Create a virtual machine
resource "azurerm_linux_virtual_machine" "test" {
  name                  = "rhcsa"
  location              = azurerm_resource_group.test.location
  resource_group_name   = azurerm_resource_group.test.name
  network_interface_ids = ["${azurerm_network_interface.test.id}"]
  admin_username      = "adminuser"
  size               = "Standard_B1s"

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.pubid
  }
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8-lvm-gen2"
    version   = "latest"
  }


}

output "public_ip" {
  value = azurerm_public_ip.test.ip_address
}

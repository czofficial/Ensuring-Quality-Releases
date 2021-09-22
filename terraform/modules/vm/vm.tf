resource "azurerm_network_interface" "test" {
  name                = "${var.prefix}-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_address_id
  }
}

resource "azurerm_linux_virtual_machine" "test" {
  name                = "${var.prefix}-vm"
  location            = var.location
  resource_group_name = var.resource_group
  size                = "Standard_B1s"
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.test.id]
  admin_ssh_key {
    username   = "adminuser"
    #username   = "var.admin_username"
    #public_key = file("~/.ssh/id_rsa.pub")
    #public_key = file("/home/vsts/work/_temp/id_rsa.pub")
    #public_key = file("/home/cz.official/.ssh/authorized_keys/id_rsa.pub")
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3k+Ba14zxTiNdbcI0+zRYN2qbTUKROkO9EV/Cc4ONDJoNLQ7V/cvNtk+Rpl6b8hEdU57PCs4B2t6HBZPwqJx0s277A1mfYKWw6RkOoZapKH8kXkg60p7lTRhuIPMDv27tVsF/gAlRWbb2VkltQ4Fqq5IF0FNd7R7w7vk5dFMJ6ndf6z9lVaoKOvqT+vAXAFeexizlngIBTYtrLisnn55HZeW0skBQaA0QwE4Czoorgd2dtDhtuU21tlP7PBei0KA4EISGXK3rLd8HsdnwwnGhcatQDohQdLA7jWp/Lf9lEB/rand8bAPePBE/lPj+bL+3NdIswF4U5kk67U1HrDgh0gEToXdCMOO75EPqZUqdV1Y822SiJgXOfGRzLMeTILW4FHqm/el8eG4nNSXxra0gXyyNTTCfQnNA1yTZqOrnFZGIx6tURcuMnD5p9JrlQOK3U91en5zzEoJLDjpDMVQT2fN8VKApIIAExBfUb2Z4N31lixKnEZ4wqFYlVwLTGbcIq61yn6V+UannZHdX+PjJWPULDvr6SOrVlwPoe1DVHptvn/75NFtGToojxFkUREJI/jF3eXwO4ZultJ2nwC3w79/i4rLRPqzPXrGw16JD+ucriziAVSkRIKGLeRYLBrWeMCdpyaaYEWxYJyjYXju7uM11vVxLVEDDIFkzRnknLw== cz.official@MacBook-Pro-2017-CZ.local"
  }
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

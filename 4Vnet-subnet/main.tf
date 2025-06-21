resource "azurerm_resource_group" "main" {
    name = "rg-${var.application_name}-${var.environment_name}"
    location = var.primary_location
  
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.application_name}-${var.environment_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.base_address_space]
#   dns_servers         = ["10.0.0.4", "10.0.0.5"]

}

locals {
  bastian_address_space = cidrsubnet(var.base_address_space, 4, 0) #to go from 22 to 26 we need 4 bits
  bravo_address_space   = cidrsubnet(var.base_address_space, 2, 1) # 10.40.1.0/24
  charlie_address_space = cidrsubnet(var.base_address_space, 2, 2) # 10.40.2.0/24
  delta_address_space   = cidrsubnet(var.base_address_space, 2, 3) # 10.40.3.0/24
}
#   alpha_address_space   = cidrsubnet(var.base_address_space, 2, 0)  10.39.0.0/24


# resource "azurerm_subnet" "alpha" {
#   name                 = "snet-alpha"
#   resource_group_name  = azurerm_resource_group.main.name
#   virtual_network_name = azurerm_virtual_network.main.name
#   address_prefixes     = [local.alpha_address_space]
# }

# 10.40.0.0/26 for the bastion (10.40.0.0 to 10.40.0.63)

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.bastian_address_space]
}
resource "azurerm_subnet" "bravo" {
  name                 = "snet-bravo"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.bravo_address_space]
}

resource "azurerm_subnet" "charlie" {
  name                 = "snet-charlie"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.charlie_address_space]
}

resource "azurerm_subnet" "delta" {
  name                 = "snet-delta"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.delta_address_space]
}

# you dont need nsg for bastion
# resource "azurerm_network_security_group" "remote_access" {
#   name                = "nsg-${var.application_name}-${var.environment_name}-remote_access"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name

#   security_rule {
#     name                       = "ssh"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = chomp(data.http.my_ip.response_body)
#     destination_address_prefix = "*"
#   }

  
# }


# resource "azurerm_subnet_network_security_group_association" "alpha_remote_access" {
#   subnet_id                 = azurerm_subnet.alpha.id
#   network_security_group_id = azurerm_network_security_group.remote_access.id
# }

data "http" "my_ip" {
    url = "https://api.ipify.org"
}


resource "azurerm_public_ip" "bastion" {
  name                = "pip-${var.application_name}-${var.environment_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "main" {
  name                = "bas-${var.application_name}-${var.environment_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}
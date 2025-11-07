

resource "azurerm_network_security_group" "nsg" {
  for_each = var.nsgs

  name                = each.value.nsg_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  # Optional: Tags
  tags = each.value.tags 

  dynamic "security_rule" {
    for_each = each.value.security_rule == null ? [] : each.value.security_rule
    content {
      name                                       = security_rule.value.name
      priority                                   = security_rule.value.priority
      direction                                  = security_rule.value.direction
      access                                     = security_rule.value.access
      protocol                                   = security_rule.value.protocol

      # Optional arguments using ternary condition
      description                                = security_rule.value.description 
      source_port_range                          = security_rule.value.source_port_range 
      source_port_ranges                         = security_rule.value.source_port_ranges 
      destination_port_range                     = security_rule.value.destination_port_range 
      destination_port_ranges                    = security_rule.value.destination_port_ranges
      source_address_prefix                      = security_rule.value.source_address_prefix 
      source_address_prefixes                    = security_rule.value.source_address_prefixes 
      destination_address_prefix                 = security_rule.value.destination_address_prefix
      destination_address_prefixes               = security_rule.value.destination_address_prefixes 
      source_application_security_group_ids      = security_rule.value.source_application_security_group_ids 
      destination_application_security_group_ids = security_rule.value.destination_application_security_group_ids
    }
  }
}





# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "associate" {
  for_each = var.nsgs
  subnet_id                 = data.azurerm_subnet.subnet_id[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}
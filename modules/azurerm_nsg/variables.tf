variable "nsgs" {
    type = map(object({
      nsg_name = string
      resource_group_name = string
      location = string
      subnet_name = string
      virtual_network_name = string
      tags = optional(map(string))

      security_rule = optional(list(object({
        name = string
        priority = number
        direction = string
        access = string
        protocol = string 
        # Optional arguments
        description                                = optional(string)
        source_port_range                          = optional(string)
        source_port_ranges                         = optional(list(string))
        destination_port_range                     = optional(string)
        destination_port_ranges                    = optional(list(string))
        source_address_prefix                      = optional(string)
        source_address_prefixes                    = optional(list(string))
        destination_address_prefix                 = optional(string)
        destination_address_prefixes               = optional(list(string))
        source_application_security_group_ids      = optional(list(string))
        destination_application_security_group_ids = optional(list(string))
      })))
    }))
}
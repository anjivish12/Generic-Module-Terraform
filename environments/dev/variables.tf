variable "rgs" {
  type = map(object({
    name       = string
    location   = string
    managed_by = optional(string)
    tags       = optional(map(string))
  }))
}

variable "vnets" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)
    tags                = optional(map(string))
    ip_address_pool = optional(list(object({
      id                     = string
      number_of_ip_addresses = string
    })), [])

    # Optional simple fields
    bgp_community                  = optional(string)
    dns_servers                    = optional(list(string))
    edge_zone                      = optional(string)
    flow_timeout_in_minutes        = optional(number)
    private_endpoint_vnet_policies = optional(string)

    # Optional DDoS Protection Plan
    ddos_protection_plan = optional(object({
      id     = string
      enable = bool
    }))

    # Optional Encryption
    encryption = optional(object({
      enforcement = string
    }))

    # Optional Subnets
    subnet = optional(list(object({
      subnet_name                                   = string
      address_prefixes                              = list(string)
      security_group                                = optional(string)
      default_outbound_access_enabled               = optional(bool)
      private_endpoint_network_policies             = optional(string)
      private_link_service_network_policies_enabled = optional(bool)
      route_table_id                                = optional(string)
      service_endpoints                             = optional(list(string))
      service_endpoint_policy_ids                   = optional(list(string))

      # Optional delegation block
      delegation = optional(list(object({
        name = string

        service_delegation = optional(object({
          name    = string
          actions = optional(list(string))
        }))
      })))
    })))
  }))
}

variable "pips" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    allocation_method   = string
    # Optional
    zones                   = optional(list(string))
    ddos_protection_mode    = optional(string) # Disabled, Enabled, VirtualNetworkInherited
    ddos_protection_plan_id = optional(string)
    domain_name_label       = optional(string)
    domain_name_label_scope = optional(string) # NoReuse, ResourceGroupReuse, SubscriptionReuse, TenantReuse
    edge_zone               = optional(string)
    idle_timeout_in_minutes = optional(number)
    ip_tags                 = optional(map(string))
    ip_version              = optional(string) # IPv4 or IPv6
    public_ip_prefix_id     = optional(string)
    reverse_fqdn            = optional(string)
    sku                     = optional(string) # Basic or Standard
    sku_tier                = optional(string) # Regional or Global
    tags                    = optional(map(string))
  }))

}

variable "vms" {
  type = map(object({
    # data block variable
    subnet_name = string
    vnet_name   = string
    pip_name    = string
    kv_name = string
    secret_name = string
    secret_value = string
    # NIC resource details
    nic_name            = string
    location            = string
    resource_group_name = string
    ip_configuration = list(object({
      name                          = string
      subnet_id                     = optional(string)
      private_ip_address_allocation = string # "Dynamic" or "Static"
      public_ip_address_id          = optional(string)

      private_ip_address                                 = optional(string)
      private_ip_address_version                         = optional(string, "IPv4")
      gateway_load_balancer_frontend_ip_configuration_id = optional(string)
      primary                                            = optional(bool, false)
    }))

    # Optional NIC-level settings
    auxiliary_mode                 = optional(string)
    auxiliary_sku                  = optional(string)
    dns_servers                    = optional(list(string))
    ip_forwarding_enabled          = optional(bool, false)
    accelerated_networking_enabled = optional(bool, false)
    internal_dns_name_label        = optional(string)

    vm_name        = string
    size           = string
    admin_username = string
    admin_password = string

    os_disk = list(object({
      caching                   = string
      storage_account_type      = optional(string)
      disk_size_gb              = optional(number)
      name                      = optional(string)
      write_accelerator_enabled = optional(bool)
      diff_disk_settings = optional(object({
        option    = string
        placement = optional(string)
      }))
      disk_encryption_set_id           = optional(string)
      secure_vm_disk_encryption_set_id = optional(string)
      security_encryption_type         = optional(string)
    }))

    source_image_reference = optional(list(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })))


    identity = optional(object({
      type         = string
      identity_ids = list(string)
    }))

    additional_capabilities = optional(object({
      ultra_ssd_enabled   = bool
      hibernation_enabled = bool
    }))

    admin_ssh_key = optional(object({
      username   = string
      public_key = string
    }))

    boot_diagnostics = optional(object({
      storage_account_uri = string
    }))

    plan = optional(object({
      name      = string
      product   = string
      publisher = string
    }))

    os_image_notification = optional(object({
      timeout = string
    }))

    termination_notification = optional(object({
      enabled = bool
      timeout = optional(string)
    }))

    source_image_id                                        = optional(string)
    allow_extension_operations                             = optional(bool)
    availability_set_id                                    = optional(string)
    bypass_platform_safety_checks_on_user_schedule_enabled = optional(bool)
    capacity_reservation_group_id                          = optional(string)
    computer_name                                          = optional(string)
    custom_data                                            = optional(string)
    dedicated_host_id                                      = optional(string)
    dedicated_host_group_id                                = optional(string)
    disk_controller_type                                   = optional(string)
    edge_zone                                              = optional(string)
    encryption_at_host_enabled                             = optional(bool)
    eviction_policy                                        = optional(string)
    extensions_time_budget                                 = optional(string)
    gallery_application = optional(list(object({
      version_id                                  = string
      automatic_upgrade_enabled                   = optional(string)
      configuration_blob_uri                      = optional(string)
      order                                       = optional(number)
      tag                                         = optional(map(string))
      treat_failure_as_deployment_failure_enabled = optional(bool)

    })))
    patch_assessment_mode        = optional(string)
    patch_mode                   = optional(string)
    max_bid_price                = optional(number)
    platform_fault_domain        = optional(number)
    priority                     = optional(string)
    provision_vm_agent           = optional(bool)
    proximity_placement_group_id = optional(string)
    reboot_setting               = optional(string)
    secure_boot_enabled          = optional(bool)
    user_data                    = optional(string)
    vtpm_enabled                 = optional(bool)
    virtual_machine_scale_set_id = optional(string)
    zone                         = optional(string)
  }))

}
variable "keys" {
  type = map(object({
    kv_name  = string
    location = string
    rg_name  = string
    sku_name = string
    access_policy = optional(list(object({
      tenant_id               = string
      object_id               = string
      application_id          = optional(string)
      certificate_permissions = optional(list(string))
      key_permissions         = optional(list(string))
      secret_permissions      = optional(list(string))
      storage_permissions     = optional(list(string))
    })))

    enabled_for_deployment          = optional(bool)
    enabled_for_disk_encryption     = optional(bool)
    enabled_for_template_deployment = optional(bool)
    rbac_authorization_enabled      = optional(bool)
    network_acls = optional(object({
      bypass                     = string
      default_action             = string
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
    }))

    purge_protection_enabled      = optional(bool)
    public_network_access_enabled = optional(bool)
    soft_delete_retention_days    = optional(number)
    tags                          = optional(map(string))
  }))
}

variable "secrets" {

  type = map(object({
    # Required
    kv_name     = string
    rg_name     = string
    secret_name = string

    # Optional values (exactly one must be defined)
    secret_value            = optional(string)
    secret_value_wo         = optional(string)
    secret_value_wo_version = optional(number)

    # Optional metadata
    content_type    = optional(string)
    not_before_date = optional(string)
    expiration_date = optional(string)
    tags            = optional(map(string))
  }))
}
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

variable "servers" {
    
    type = map(object({
    name                         = string
    resource_group_name          = string
    location                     = string
    version                      = string
    administrator_login          = optional(string)
    administrator_login_password = optional(string)
    minimum_tls_version          = optional(string, "1.2")
    public_network_access_enabled = optional(bool, true)

    azuread_administrator = optional(list(object({
      login_username              = string
      object_id                   = string
      tenant_id                   = optional(string)
      azuread_authentication_only = optional(bool, false)
    })))

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))

    tags = optional(map(string))
  }))
}

variable "databases" {
  description = "Map of Azure SQL Databases to deploy."

  type = map(object({
    server_name = string
    resource_group_name = string
    name         = string
    collation    = optional(string)
    license_type = optional(string)
    max_size_gb  = optional(number)
    sku_name     = optional(string)
    enclave_type = optional(string)

    auto_pause_delay_in_minutes             = optional(number)
    create_mode                             = optional(string)
    creation_source_database_id             = optional(string)
    elastic_pool_id                         = optional(string)
    geo_backup_enabled                      = optional(bool)
    maintenance_configuration_name          = optional(string)
    ledger_enabled                          = optional(bool)
    min_capacity                            = optional(number)
    restore_point_in_time                   = optional(string)
    recover_database_id                     = optional(string)
    recovery_point_id                       = optional(string)
    restore_dropped_database_id             = optional(string)
    restore_long_term_retention_backup_id   = optional(string)
    read_replica_count                      = optional(number)
    read_scale                              = optional(bool)
    sample_name                             = optional(string)
    storage_account_type                    = optional(string)
    transparent_data_encryption_enabled     = optional(bool)
    transparent_data_encryption_key_vault_key_id = optional(string)
    transparent_data_encryption_key_automatic_rotation_enabled = optional(bool)
    zone_redundant                          = optional(bool)
    secondary_type                          = optional(string)

    import = optional(object({
      storage_uri                  = string
      storage_key                  = string
      storage_key_type             = string
      administrator_login          = string
      administrator_login_password = string
      authentication_type          = string
      storage_account_id           = optional(string)
    }))

    threat_detection_policy = optional(object({
      state                      = optional(string)
      disabled_alerts            = optional(list(string))
      email_account_admins       = optional(string)
      email_addresses            = optional(list(string))
      retention_days             = optional(number)
      storage_account_access_key = optional(string)
      storage_endpoint           = optional(string)
    }))

    long_term_retention_policy = optional(object({
      weekly_retention  = optional(string)
      monthly_retention = optional(string)
      yearly_retention  = optional(string)
      week_of_year      = optional(number)
    }))

    short_term_retention_policy = optional(object({
      retention_days           = number
      backup_interval_in_hours = optional(number)
    }))

    identity = optional(object({
      type         = string
      identity_ids = list(string)
    }))

    tags = optional(map(string))
  }))
}


variable "stgs" {
  type = map(object({
    name                     = string
    resource_group_name      = string
    location                 = string
    account_kind             = optional(string)
    account_tier             = string
    account_replication_type = string
    provisioned_billing_model_version = optional(string)
    cross_tenant_replication_enabled  = optional(bool)
    access_tier               = optional(string)
    edge_zone                 = optional(string)
    https_traffic_only_enabled = optional(bool)
    min_tls_version           = optional(string)
    allow_nested_items_to_be_public = optional(bool)
    shared_access_key_enabled = optional(bool)
    public_network_access_enabled = optional(bool)
    default_to_oauth_authentication = optional(bool)
    is_hns_enabled            = optional(bool)
    nfsv3_enabled             = optional(bool)
    large_file_share_enabled  = optional(bool)
    local_user_enabled        = optional(bool)
    infrastructure_encryption_enabled = optional(bool)
    sftp_enabled              = optional(bool)
    dns_endpoint_type         = optional(string)
    queue_encryption_key_type = optional(string)
    table_encryption_key_type = optional(string)
    allowed_copy_scope        = optional(string)
    tags = optional(map(string))

    identity = optional(list(object({
      type         = string
      identity_ids = optional(list(string))
    })))

    custom_domain = optional(list(object({
      name          = string
      use_subdomain = optional(bool)
    })))

    customer_managed_key = optional(list(object({
      key_vault_key_id        = optional(string)
      managed_hsm_key_id      = optional(string)
      user_assigned_identity_id = string
    })))

    network_rules = optional(list(object({
      default_action            = string
      bypass                    = optional(list(string))
      ip_rules                  = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
      private_link_access = optional(list(object({
        endpoint_resource_id = string
        endpoint_tenant_id   = optional(string)
      })))
    })))

    blob_properties = optional(list(object({
      versioning_enabled            = optional(bool)
      change_feed_enabled           = optional(bool)
      change_feed_retention_in_days = optional(number)
      default_service_version       = optional(string)
      last_access_time_enabled      = optional(bool)
      delete_retention_policy = optional(list(object({
        days                    = optional(number)
        permanent_delete_enabled = optional(bool)
      })))
      restore_policy = optional(list(object({
        days = number
      })))
      container_delete_retention_policy = optional(list(object({
        days = optional(number)
      })))
      cors_rule = optional(list(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })))
    })))

    static_website = optional(list(object({
      index_document     = optional(string)
      error_404_document = optional(string)
    })))
  }))
}

variable "acrs" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku                 = string
    admin_enabled       = optional(bool)
    public_network_access_enabled = optional(bool)
    quarantine_policy_enabled     = optional(bool)
    retention_policy_in_days      = optional(number)
    trust_policy_enabled          = optional(bool)
    zone_redundancy_enabled       = optional(bool)
    export_policy_enabled         = optional(bool)
    anonymous_pull_enabled        = optional(bool)
    data_endpoint_enabled         = optional(bool)
    network_rule_bypass_option    = optional(string)
    tags = optional(map(string))

    identity = optional(list(object({
      type         = string
      identity_ids = optional(list(string))
    })))

    encryption = optional(list(object({
      key_vault_key_id   = string
      identity_client_id = string
    })))

    network_rule_set = optional(list(object({
      default_action = optional(string)
      ip_rule = optional(list(object({
        action   = string
        ip_range = string
      })))
    })))

    georeplications = optional(list(object({
      location                 = string
      regional_endpoint_enabled = optional(bool)
      zone_redundancy_enabled   = optional(bool)
      tags = optional(map(string))
    })))
  }))
}

variable "aks" {
    type = map(object({
      name = string
      resource_group_name = string
      location = string
      dns_prefix = string
      default_node_pool = list(object({
        name = string
        node_count = number
        vm_size = string 
      }))
      identity = list(object({
        type = string
      }))
    }))  
}

resource "azurerm_network_interface" "nic" {
  for_each = var.vms

  # Required
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
# Dynamic IP configurations
  dynamic "ip_configuration" {
    for_each = each.value.ip_configuration
    content {
      name                                         = ip_configuration.value.name
      subnet_id                                    = data.azurerm_subnet.subnetids[each.key].id
      private_ip_address_allocation                = ip_configuration.value.private_ip_address_allocation
      public_ip_address_id                         = data.azurerm_public_ip.pipids[each.key].id

      private_ip_address                           = ip_configuration.value.private_ip_address
      private_ip_address_version                   = ip_configuration.value.private_ip_address_version
      gateway_load_balancer_frontend_ip_configuration_id = ip_configuration.value.gateway_load_balancer_frontend_ip_configuration_id
      primary                                      = ip_configuration.value.primary
    }
  }
  # Optional arguments
  auxiliary_mode                = each.value.auxiliary_mode
  auxiliary_sku                 = each.value.auxiliary_sku
  dns_servers                   = each.value.dns_servers
  edge_zone                     = each.value.edge_zone
  ip_forwarding_enabled         = each.value.ip_forwarding_enabled
  accelerated_networking_enabled = each.value.accelerated_networking_enabled
  internal_dns_name_label       = each.value.internal_dns_name_label

  
}


resource "azurerm_linux_virtual_machine" "virtual_machine" {
  for_each                        = var.vms
  name                            = each.value.vm_name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  size                            = each.value.size
  admin_username                  = data.azurerm_key_vault_secret.secret_name[each.key].name
  admin_password                  = data.azurerm_key_vault_secret.secret_value[each.key].value
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id,
  ]

dynamic "os_disk" {
    for_each = each.value.os_disk == null ? [] : each.value.os_disk
    content {
      caching              = os_disk.value.caching
      storage_account_type = os_disk.value.storage_account_type
      disk_size_gb         = os_disk.value.disk_size_gb
      name                 = os_disk.value.name
      write_accelerator_enabled = os_disk.value.write_accelerator_enabled
      dynamic "diff_disk_settings" {
        for_each = os_disk.value.diff_disk_settings == null ? [] : [os_disk.value.diff_disk_settings]
        content {
           option    = diff_disk_settings.value.option
           placement = diff_disk_settings.value.placement
          
        }
       
      }
      disk_encryption_set_id       = os_disk.value.disk_encryption_set_id
      secure_vm_disk_encryption_set_id = os_disk.value.secure_vm_disk_encryption_set_id
      security_encryption_type     = os_disk.value.security_encryption_type
    }
}

dynamic "source_image_reference" {
    for_each = each.value.source_image_reference == null ? [] : each.value.source_image_reference
    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }
  custom_data = base64encode(<<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install nginx -y
              sudo systemctl enable nginx
              sudo systemctl start nginx
              echo "<h1>Welcome to NGINX - deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
          EOF
  )

  dynamic "identity" {
    for_each = each.value.identity == null ? [] : [each.value.identity]
    content {
       type         = identity.value.type
       identity_ids = identity.value.identity_ids
    }
   
  }

  dynamic "additional_capabilities" {
    for_each = each.value.additional_capabilities == null ? [] :  [each.value.additional_capabilities]
    content {
      ultra_ssd_enabled  = additional_capabilities.value.ultra_ssd_enabled
    hibernation_enabled = additional_capabilities.value.hibernation_enabled
    }
    
  }

  dynamic "admin_ssh_key" {
    for_each = each.value.admin_ssh_key == null ? [] :  [each.value.admin_ssh_key]
    content {
        username   = admin_ssh_key.value.username
        public_key = admin_ssh_key.value.public_key
    }
 
  }

 dynamic  "boot_diagnostics" {
  for_each = each.value.boot_diagnostics == null ? [] : [each.value.boot_diagnostics]
  content {
    storage_account_uri = boot_diagnostics.value.storage_account_uri
  }
  }

 dynamic "plan" {
  for_each =  each.value.plan == null ? [] : [each.value.plan]
  content {
    name      = plan.value.plan.name
    product   = plan.value.plan.product
    publisher = plan.value.plan.publisher
 
  }
 }
 dynamic "os_image_notification" {
      for_each = each.value.os_image_notification == null ? [] : [each.value.os_image_notification]
    content {
      timeout = os_image_notification.value.timeout

    }
  }

  dynamic "termination_notification" {
    for_each = each.value.termination_notification == null ? [] : [each.value.termination_notification]
    content {
        enabled = termination_notification.value.enabled
        timeout = termination_notification.value.timeout
    }
 
  }

  source_image_id = each.value.source_image_id
  allow_extension_operations = each.value.allow_extension_operations
  availability_set_id = each.value.availability_set_id
  bypass_platform_safety_checks_on_user_schedule_enabled = each.value.bypass_platform_safety_checks_on_user_schedule_enabled
  capacity_reservation_group_id = each.value.capacity_reservation_group_id
  computer_name = each.value.computer_name
  # custom_data = each.value.custom_data
  dedicated_host_id = each.value.dedicated_host_id
  dedicated_host_group_id = each.value.dedicated_host_group_id
  disk_controller_type = each.value.disk_controller_type
  
  edge_zone = each.value.edge_zone
  
  encryption_at_host_enabled = each.value.encryption_at_host_enabled
  eviction_policy = each.value.eviction_policy
  extensions_time_budget = each.value.extensions_time_budget
  dynamic "gallery_application" {
    for_each = each.value.gallery_application == null ? [] : [each.value.gallery_application]
    content {
      version_id = gallery_application.value.version_id
      automatic_upgrade_enabled  = gallery_application.value.automatic_upgrade_enabled
      configuration_blob_uri = gallery_application.value.configuration_blob_uri
      order = gallery_application.value.order
      tag = gallery_application.value.tag
      treat_failure_as_deployment_failure_enabled = gallery_application.value.treat_failure_as_deployment_failure_enabled
    }
    
  }
  patch_assessment_mode = each.value.patch_assessment_mode
  patch_mode = each.value.patch_mode
  max_bid_price = each.value.max_bid_price
  platform_fault_domain = each.value.platform_fault_domain
  priority = each.value.priority
  provision_vm_agent = each.value.provision_vm_agent
  proximity_placement_group_id = each.value.proximity_placement_group_id
  reboot_setting = each.value.reboot_setting
  secure_boot_enabled = each.value.secure_boot_enabled
  user_data = each.value.user_data
  vtpm_enabled = each.value.vtpm_enabled
  virtual_machine_scale_set_id = each.value.virtual_machine_scale_set_id
  zone = each.value.zone
  
}
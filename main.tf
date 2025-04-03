resource "azurerm_api_management" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = var.sku_name
  tags                = var.tags
  zones               = var.zones

  # Virtual network configuration
  virtual_network_type = var.virtual_network_type
  dynamic "virtual_network_configuration" {
    for_each = contains(["Internal", "External"], var.virtual_network_type) ? [1] : []
    content {
      subnet_id = var.virtual_network_subnet_id
    }
  }

  # Additional locations
  dynamic "additional_location" {
    for_each = var.additional_location
    content {
      location            = additional_location.value.location
      capacity            = additional_location.value.capacity
      zones               = additional_location.value.zones
      public_ip_address_id = additional_location.value.public_ip_address_id
      gateway_disabled    = additional_location.value.gateway_disabled

      dynamic "virtual_network_configuration" {
        for_each = additional_location.value.virtual_network_configuration != null ? [additional_location.value.virtual_network_configuration] : []
        content {
          subnet_id = virtual_network_configuration.value.subnet_id
        }
      }
    }
  }

  # Certificate configuration
  dynamic "certificate" {
    for_each = var.certificate
    content {
      encoded_certificate  = certificate.value.encoded_certificate
      store_name           = certificate.value.store_name
      certificate_password = certificate.value.certificate_password
    }
  }

  # Client certificate settings
  client_certificate_enabled = var.client_certificate_enabled
  gateway_disabled          = var.gateway_disabled
  min_api_version           = var.min_api_version
  public_ip_address_id      = var.public_ip_address_id
  public_network_access_enabled = var.public_network_access_enabled
  notification_sender_email = var.notification_sender_email

  # Sign in configuration
  dynamic "sign_in" {
    for_each = var.sign_in != null ? [var.sign_in] : []
    content {
      enabled = sign_in.value.enabled
    }
  }

  # Sign up configuration
  dynamic "sign_up" {
    for_each = var.sign_up != null ? [var.sign_up] : []
    content {
      enabled = sign_up.value.enabled
      
      terms_of_service {
        consent_required = sign_up.value.terms_of_service.consent_required
        enabled         = sign_up.value.terms_of_service.enabled
        text            = sign_up.value.terms_of_service.text
      }
    }
  }

  # Tenant access configuration
  dynamic "tenant_access" {
    for_each = var.tenant_access != null ? [var.tenant_access] : []
    content {
      enabled = tenant_access.value.enabled
    }
  }

  # Protocol settings
  dynamic "protocols" {
    for_each = var.protocols != null ? [var.protocols] : []
    content {
      enable_http2 = protocols.value.enable_http2
    }
  }

  # Security settings
  dynamic "security" {
    for_each = var.security != null ? [var.security] : []
    content {
      enable_backend_ssl30 = security.value.enable_backend_ssl30
      enable_backend_tls10 = security.value.enable_backend_tls10
      enable_backend_tls11 = security.value.enable_backend_tls11
      enable_frontend_ssl30 = security.value.enable_frontend_ssl30
      enable_frontend_tls10 = security.value.enable_frontend_tls10
      enable_frontend_tls11 = security.value.enable_frontend_tls11
      tls_ecdhe_ecdsa_with_aes128_cbc_sha_ciphers_enabled = security.value.tls_ecdhe_ecdsa_with_aes128_cbc_sha_ciphers_enabled
      tls_ecdhe_ecdsa_with_aes256_cbc_sha_ciphers_enabled = security.value.tls_ecdhe_ecdsa_with_aes256_cbc_sha_ciphers_enabled
      tls_ecdhe_rsa_with_aes128_cbc_sha_ciphers_enabled = security.value.tls_ecdhe_rsa_with_aes128_cbc_sha_ciphers_enabled
      tls_ecdhe_rsa_with_aes256_cbc_sha_ciphers_enabled = security.value.tls_ecdhe_rsa_with_aes256_cbc_sha_ciphers_enabled
      tls_rsa_with_aes128_cbc_sha256_ciphers_enabled = security.value.tls_rsa_with_aes128_cbc_sha256_ciphers_enabled
      tls_rsa_with_aes128_cbc_sha_ciphers_enabled = security.value.tls_rsa_with_aes128_cbc_sha_ciphers_enabled
      tls_rsa_with_aes128_gcm_sha256_ciphers_enabled = security.value.tls_rsa_with_aes128_gcm_sha256_ciphers_enabled
      tls_rsa_with_aes256_cbc_sha256_ciphers_enabled = security.value.tls_rsa_with_aes256_cbc_sha256_ciphers_enabled
      tls_rsa_with_aes256_cbc_sha_ciphers_enabled = security.value.tls_rsa_with_aes256_cbc_sha_ciphers_enabled
      tls_rsa_with_aes256_gcm_sha384_ciphers_enabled = security.value.tls_rsa_with_aes256_gcm_sha384_ciphers_enabled
      triple_des_ciphers_enabled = security.value.triple_des_ciphers_enabled
    }
  }

  # Hostname configuration
  dynamic "hostname_configuration" {
    for_each = var.hostname_configuration != null ? [var.hostname_configuration] : []
    content {
      # Management hostnames
      dynamic "management" {
        for_each = hostname_configuration.value.management
        content {
          host_name            = management.value.host_name
          key_vault_id         = management.value.key_vault_id
          certificate          = management.value.certificate
          certificate_password = management.value.certificate_password
          negotiate_client_certificate = management.value.negotiate_client_certificate
          ssl_keyvault_identity_client_id = management.value.ssl_keyvault_identity_client_id
        }
      }

      # Portal hostnames
      dynamic "portal" {
        for_each = hostname_configuration.value.portal
        content {
          host_name            = portal.value.host_name
          key_vault_id         = portal.value.key_vault_id
          certificate          = portal.value.certificate
          certificate_password = portal.value.certificate_password
          negotiate_client_certificate = portal.value.negotiate_client_certificate
          ssl_keyvault_identity_client_id = portal.value.ssl_keyvault_identity_client_id
        }
      }

      # Developer portal hostnames
      dynamic "developer_portal" {
        for_each = hostname_configuration.value.developer_portal
        content {
          host_name            = developer_portal.value.host_name
          key_vault_id         = developer_portal.value.key_vault_id
          certificate          = developer_portal.value.certificate
          certificate_password = developer_portal.value.certificate_password
          negotiate_client_certificate = developer_portal.value.negotiate_client_certificate
          ssl_keyvault_identity_client_id = developer_portal.value.ssl_keyvault_identity_client_id
        }
      }

      # Proxy hostnames
      dynamic "proxy" {
        for_each = hostname_configuration.value.proxy
        content {
          default_ssl_binding  = proxy.value.default_ssl_binding
          host_name            = proxy.value.host_name
          key_vault_id         = proxy.value.key_vault_id
          certificate          = proxy.value.certificate
          certificate_password = proxy.value.certificate_password
          negotiate_client_certificate = proxy.value.negotiate_client_certificate
          ssl_keyvault_identity_client_id = proxy.value.ssl_keyvault_identity_client_id
        }
      }

      # SCM hostnames
      dynamic "scm" {
        for_each = hostname_configuration.value.scm
        content {
          host_name            = scm.value.host_name
          key_vault_id         = scm.value.key_vault_id
          certificate          = scm.value.certificate
          certificate_password = scm.value.certificate_password
          negotiate_client_certificate = scm.value.negotiate_client_certificate
          ssl_keyvault_identity_client_id = scm.value.ssl_keyvault_identity_client_id
        }
      }
    }
  }

  # Delegation configuration
  dynamic "delegation" {
    for_each = var.delegation != null ? [var.delegation] : []
    content {
      subscriptions_enabled     = delegation.value.subscriptions_enabled
      user_registration_enabled = delegation.value.user_registration_enabled
      url                       = delegation.value.url
      validation_key            = delegation.value.validation_key
    }
  }

  # Identity configuration
  dynamic "identity" {
    for_each = length(var.managed_identities.user_assigned_resource_ids) > 0 || var.managed_identities.system_assigned ? [1] : []
    content {
      type         = length(var.managed_identities.user_assigned_resource_ids) > 0 && var.managed_identities.system_assigned ? "SystemAssigned, UserAssigned" : length(var.managed_identities.user_assigned_resource_ids) > 0 ? "UserAssigned" : "SystemAssigned"
      identity_ids = length(var.managed_identities.user_assigned_resource_ids) > 0 ? var.managed_identities.user_assigned_resource_ids : null
    }
  }

  lifecycle {
    # This prevents errors when deleting products with subscriptions
    create_before_destroy = true

    # Optional: If you want to skip destroying default products
    ignore_changes = [
      # product
    ]
    # skip_delete_default_products = true
  }
}

# Lock resource
resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0

  name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
  scope      = azurerm_api_management.this.id
  lock_level = var.lock.kind
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete resource or child resources." : "Cannot modify the resource or its children."
}

# Role assignments
resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = azurerm_api_management.this.id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}



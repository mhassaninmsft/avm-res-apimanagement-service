#TODO
# output "private_endpoints" {
#   description = <<DESCRIPTION
#   A map of the private endpoints created.
#   DESCRIPTION
#   value       = var.private_endpoints_manage_dns_zone_group ? azurerm_private_endpoint.this_managed_dns_zone_groups : azurerm_private_endpoint.this_unmanaged_dns_zone_groups
# }

# Module owners should include the full resource via a 'resource' output
# https://azure.github.io/Azure-Verified-Modules/specs/terraform/#id-tffr2---category-outputs---additional-terraform-outputs
# To includer the full resource, uncomment the following block which is a sensitive output
output "resource" {
  description = "The API Management service resource."
  value       = azurerm_api_management.this
  sensitive = true
}

output "id" {
  description = "The ID of the API Management service."
  value       = azurerm_api_management.this.id
}

output "name" {
  description = "The name of the API Management service."
  value       = azurerm_api_management.this.name
}

output "workspace_identity" {
  description = "The identity for the created workspace."
  value = {
    principal_id = try(azurerm_api_management.this.identity[0].principal_id, null)
    type         = try(azurerm_api_management.this.identity[0].type, null)
  }
}

# output "private_endpoint_ids" {
#   description = "The resource IDs of the private endpoints created by this module"
#   value       = { for k, v in azurerm_private_endpoint.this : k => v.id }
# }

# output "private_endpoint_ip_configurations" {
#   description = "The IP configurations of the private endpoints created by this module"
#   value = { for pe_key, pe in azurerm_private_endpoint.this : pe_key => {
#     for ip_config in pe.ip_configuration : ip_config.name => {
#       private_ip_address = ip_config.private_ip_address
#       member_name        = ip_config.member_name
#       subresource_name   = ip_config.subresource_name
#     }
#   } }
# }

# output "private_endpoint_network_interfaces" {
#   description = "The network interfaces created for the private endpoints"
#   value       = { for k, v in azurerm_private_endpoint.this : k => v.network_interface[0].id }
# }

# output "private_endpoint_private_ip_addresses" {
#   description = "The primary private IP addresses of the private endpoints created by this module"
#   value       = { for k, v in azurerm_private_endpoint.this : k => v.private_service_connection[0].private_ip_address }
# }

output "private_ip_addresses" {
  description = "The private IP addresses of the private endpoints created by this module"
  value       = azurerm_api_management.this.private_ip_addresses
}

output "apim_gateway_url" {
  description = "The gateway URL of the API Management service."
  value       = azurerm_api_management.this.gateway_url
}
output "apim_management_url" {
  description = "The management URL of the API Management service."
  value       = azurerm_api_management.this.management_api_url
}

output "developer_portal_url" {
  description = "The publisher URL of the API Management service."
  value       = azurerm_api_management.this.developer_portal_url
}

output "private_endpoint" {
  description = "The private endpoints created for the API Management service."
  value       = azurerm_private_endpoint.this
}

// ...existing code...

output "gateway_regional_url" {
  description = "The Region URL for the Gateway of the API Management Service."
  value       = azurerm_api_management.this.gateway_regional_url
}

output "portal_url" {
  description = "The URL for the Publisher Portal associated with this API Management service."
  value       = azurerm_api_management.this.portal_url
}

output "public_ip_addresses" {
  description = "The Public IP addresses of the API Management Service."
  value       = azurerm_api_management.this.public_ip_addresses
}

output "scm_url" {
  description = "The URL for the SCM (Source Code Management) Endpoint associated with this API Management service."
  value       = azurerm_api_management.this.scm_url
}

output "additional_locations" {
  description = "Information about additional locations for the API Management Service."
  value = [
    for location in azurerm_api_management.this.additional_location : {
      gateway_regional_url = location.gateway_regional_url
      public_ip_addresses  = location.public_ip_addresses
      private_ip_addresses = location.private_ip_addresses
    }
  ]
}

output "tenant_access" {
  description = "The tenant access information for the API Management Service."
  value = {
    tenant_id      = try(azurerm_api_management.this.tenant_access[0].tenant_id, null)
    primary_key    = try(azurerm_api_management.this.tenant_access[0].primary_key, null)
    secondary_key  = try(azurerm_api_management.this.tenant_access[0].secondary_key, null)
  }
  sensitive = true
}

output "hostname_configuration" {
  description = "The hostname configuration for the API Management Service."
  value = {
    proxy = [
      for proxy in try(azurerm_api_management.this.hostname_configuration[0].proxy, []) : {
        certificate_source = proxy.certificate_source
        certificate_status = proxy.certificate_status
      }
    ]
  }
}

output "certificates" {
  description = "Certificate information for the API Management Service."
  value = [
    for cert in azurerm_api_management.this.certificate : {
      expiry     = cert.expiry
      thumbprint = cert.thumbprint
      subject    = cert.subject
    }
  ]
}

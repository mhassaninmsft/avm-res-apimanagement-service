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
# output "resource" {
#   description = "The API Management service resource."
#   value       = azurerm_api_management.this
#   sensitive = true
# }

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

# output apim_identities {
#   description = "The identity for the created API Management service."
#   value = azurerm_api_management.this.identity
# }

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

# output "apim_publisher_url" {
#   description = "The publisher URL of the API Management service."
#   value       = azurerm_api_management.this.publisher_url
# }

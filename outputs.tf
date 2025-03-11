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

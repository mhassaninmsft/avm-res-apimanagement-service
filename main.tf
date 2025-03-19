
resource "azurerm_api_management" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name           = var.sku_name
  tags               = var.tags
  # virtual_network_configuration {
  #   subnet_id = var.virtual_network_subnet_id
  # }

  # This implementation uses a dynamic block with for_each to conditionally create the virtual_network_configuration block only when virtual_network_type is either "Internal" or "External".
  # If the type is "None", the block won't be included in the resource.
  dynamic "virtual_network_configuration" {
    for_each = contains(["Internal", "External"], var.virtual_network_type) ? [1] : []
    content {
      subnet_id = var.virtual_network_subnet_id
    }
  }
  virtual_network_type = var.virtual_network_type
  # min_api_version = "2024-06-01-preview"

  dynamic "identity" {
    for_each = local.managed_identities.system_assigned_user_assigned

    content {
      type                       = identity.value.type
      identity_ids              = identity.value.user_assigned_resource_ids
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



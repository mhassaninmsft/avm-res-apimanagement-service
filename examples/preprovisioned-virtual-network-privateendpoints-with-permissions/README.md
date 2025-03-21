<!-- BEGIN_TF_DOCS -->
# Preprovisioned Virtual Network Example

This deploys the module with the virtual network settings provided by the user. They must specify a Virtual Network Type, which can be "External", "Internal", or "None". Providing "None" will deploy an API Management instance that is not secured within a virtual network. Visit [APIM Networking](https://learn.microsoft.com/en-us/azure/api-management/virtual-network-concepts) to learn more about virtual network configurations for API Management.

```hcl
terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.21.9"
    }
    modtm = {
      source  = "Azure/modtm"
      version = "0.3.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    #     api_management {
    # purge_soft_delete_on_destroy = false
    #     min_api_version = "2024-10-01-preview"
    #     }
  }
}

# This allows us to randomize the region for the resource group.
module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "0.3.0"
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"
}

resource "azurerm_resource_group" "this" {
  name     = module.naming.resource_group.name_unique
  location = module.regions.regions[random_integer.region_index.result].name
}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "this" {
  source = "../../"
  # source             = "Azure/avm-<res/ptn>-<name>/azurerm"
  # ...
  location                      = azurerm_resource_group.this.location
  name                          = module.naming.api_management.name_unique
  resource_group_name           = azurerm_resource_group.this.name
  publisher_email               = var.publisher_email
  publisher_name                = var.publisher_name
  sku_name                      = var.sku
  tags                          = var.tags
  enable_telemetry              = var.enable_telemetry
  public_network_access_enabled = var.virtual_network_type == "Internal" ? false : true
  public_ip_address_id          = var.virtual_network_type == "Internal" ? "" : var.public_ip_address_id
  virtual_network_type          = var.virtual_network_type
  virtual_network_configuration = var.virtual_network_type == "None" ? {} : {
    subnet_id = var.subnet_id
  }
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9, < 2.0)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 2.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (4.21.9)

- <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) (0.3.2)

- <a name="requirement_random"></a> [random](#requirement\_random) (3.6.2)

## Resources

The following resources are used by this module:

- [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.21.9/docs/resources/resource_group) (resource)
- [random_integer.region_index](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/integer) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_publisher_email"></a> [publisher\_email](#input\_publisher\_email)

Description:   This variable is the publicly face email for the publisher of the APIs made  
  available in APIM.

Type: `string`

### <a name="input_publisher_name"></a> [publisher\_name](#input\_publisher\_name)

Description:   This variable is the publicly facing name for the publisher of the APIs made  
  available in APIM.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_public_ip_address_id"></a> [public\_ip\_address\_id](#input\_public\_ip\_address\_id)

Description:   This variable is the Azure resource ID for the public IP address of the APIM deployment.  
  If this field is left blank and an IP address is required, it will be generated automatically.

Type: `string`

Default: `""`

### <a name="input_sku"></a> [sku](#input\_sku)

Description:   This variable is the SKU used for the APIM deployment. The default is Developer\_1.  
  The sku\_name is a combination of type (Consumer, Developer, etc) and capacity (number  
  of deployed units).

Type: `string`

Default: `"Developer_1"`

### <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id)

Description: This variable is a subnet ID (Azure resource ID) for the APIM resource. This subnet  
must have port 3443 open, as well as other port configuration defined here:  
https://learn.microsoft.com/en-us/azure/api-management/virtual-network-reference?tabs=stv2.  
Ensure 'Delegate subnet to a service' is set to None for the provided subnet.

Type: `string`

Default: `""`

### <a name="input_tags"></a> [tags](#input\_tags)

Description:   A map of tags to assign to the resource.

Type: `map(string)`

Default: `{}`

### <a name="input_virtual_network_type"></a> [virtual\_network\_type](#input\_virtual\_network\_type)

Description:   This variable controls whether to use an internal, external, or no virtual network.  
  when deploying APIM. Supported values are 'Internal', 'External', or 'None'.

Type: `string`

Default: `"None"`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_naming"></a> [naming](#module\_naming)

Source: Azure/naming/azurerm

Version: 0.3.0

### <a name="module_regions"></a> [regions](#module\_regions)

Source: Azure/avm-utl-regions/azurerm

Version: 0.3.0

### <a name="module_this"></a> [this](#module\_this)

Source: ../../

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->
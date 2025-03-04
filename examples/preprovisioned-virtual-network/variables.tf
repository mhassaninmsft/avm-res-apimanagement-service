variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "publisher_name" {
  type        = string
  description = <<DESCRIPTION
  This variable is the publicly facing name for the publisher of the APIs made
  available in APIM.
  DESCRIPTION
}

variable "publisher_email" {
  type        = string
  description = <<DESCRIPTION
  This variable is the publicly face email for the publisher of the APIs made
  available in APIM.
  DESCRIPTION
}

variable "sku" {
  type        = string
  default     = "Developer_1"
  description = <<DESCRIPTION
  This variable is the SKU used for the APIM deployment. The default is Developer_1.
  The sku_name is a combination of type (Consumer, Developer, etc) and capacity (number
  of deployed units).
  DESCRIPTION
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
  A map of tags to assign to the resource.
  DESCRIPTION
}

variable "public_ip_address_id" {
  type        = string
  default     = ""
  description = <<DESCRIPTION
  This variable is the Azure resource ID for the public IP address of the APIM deployment.
  If this field is left blank and an IP address is required, it will be generated automatically.
  DESCRIPTION
}

variable "virtual_network_type" {
  type        = string
  default     = "None"
  description = <<DESCRIPTION
  This variable controls whether to use an internal, external, or no virtual network.
  when deploying APIM. Supported values are 'Internal', 'External', or 'None'.
  DESCRIPTION
}

variable "subnet_id" {
  type        = string
  default     = ""
  description = <<DESCRIPTION
This variable is a subnet ID (Azure resource ID) for the APIM resource. This subnet
must have port 3443 open, as well as other port configuration defined here:
https://learn.microsoft.com/en-us/azure/api-management/virtual-network-reference?tabs=stv2.
Ensure 'Delegate subnet to a service' is set to None for the provided subnet.
DESCRIPTION
}
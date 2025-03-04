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

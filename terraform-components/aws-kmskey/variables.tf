### KMS Key
variable "alias_name" {
  description = "Name for the kms key alias. A random string will be appended depending on the 'append_random_suffix' variable"
  type        = string
}

variable "description" {
  description = "The description to give to the key"
  type        = string
}

variable "append_random_suffix" {
  description = "Append a random string to the alias name. Default: true (yes)"
  type        = bool
  default     = true
}

variable "deletion_window" {
  description = "Number of days before a key actually gets deleted once it's been scheduled for deletion. Valid value between 7 and 30 days"
  type        = number
  default     = 30
}

### Key Type info
variable "key_type" {
  description = "Indicate which kind of key to create: 'service' for key used by services; 'direct' for other keys. Must provide service_key or direct_key maps depending on the type"
  type        = string
  validation {
    condition     = var.key_type == "service" || var.key_type == "direct"
    error_message = "The key_type must be 'service' or 'direct'."
  }
}

variable "service_key_info" {
  description = "Information required for a 'service' key"
  type = object({
    # List of AWS service names for the kms:ViaService policy condition
    aws_service_names = list(string)
    # List of caller account IDs for the kms:CallerAccount policy condition
    caller_account_ids = list(string)
  })
  default = {
    aws_service_names  = []
    caller_account_ids = []
  }
}

variable "kms_key_conditions" {
  description = "[Optional] List of conditions to add to the KMS key Via-Service policy statement"
  type = set(object({
    test     = string
    variable = string
    values   = list(string)
  }))

  default = []
}

variable "direct_key_principal" {
  description = "Principal Information - Type & Identifier required for a 'direct' key"
  type        = map(list(string))
  default = {
    AWS = []
  }
  validation {
    condition     = alltrue([for principal_type in keys(var.direct_key_principal) : contains(["AWS", "Service"], principal_type)])
    error_message = "Valid values for Principal type are AWS and Service."
  }
}

### Metadata
variable "tags" {
  description = "Tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys"
  type        = map(string)
  default     = {}
}

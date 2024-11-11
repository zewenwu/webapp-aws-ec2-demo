### Security Group
variable "service_name" {
  description = "The name of the service for which the security group is being created"
  type        = string
}

variable "security_group_description" {
  description = "The description of the security group"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "The VPC ID for the security group"
  type        = string
}

### Public internet ingress rule
variable "allow_ingress_internet" {
  description = "Whether to allow ingress from the internet for the security group"
  type        = bool
  default     = false
}

variable "ingress_internet_port" {
  description = "The port to allow from the internet"
  type        = number
  default     = 0
}

variable "ingress_internet_protocol" {
  description = "The protocol to allow from the internet"
  type        = string
  default     = "-1"
}

### Additional security group ingress rules
variable "allow_additional_sg_ingress_ids" {
  description = "List of additional security group IDs to allow ingress from"
  type        = list(string)
  default     = []
}

variable "additional_sg_port" {
  description = "The port to allow in the additional security group"
  type        = number
  default     = 0
}

variable "additional_sg_protocol" {
  description = "The protocol to allow in the additional security group"
  type        = string
  default     = "-1"
}

### Metadata
variable "tags" {
  description = "Tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys"
  type        = map(string)
  default     = {}
}

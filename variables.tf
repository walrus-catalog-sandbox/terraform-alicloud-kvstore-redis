#
# Contextual Fields
#

variable "context" {
  description = <<-EOF
Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.

Examples:
```
context:
  project:
    name: string
    id: string
  environment:
    name: string
    id: string
  resource:
    name: string
    id: string
```
EOF
  type        = map(any)
  default     = {}
}

#
# Infrastructure Fields
#

variable "infrastructure" {
  description = <<-EOF
Specify the infrastructure information for deploying.

Examples:
```
infrastructure:
  vpc_id: string                  # the ID of the VPC where the redis service applies
  kms_key_id: sting,optional      # the ID of the KMS key which to encrypt the redis data
  domain_suffix: string           # a private DNS namespace of the CloudMap where to register the applied redis service
```
EOF
  type = object({
    vpc_id        = string
    kms_key_id    = optional(string)
    domain_suffix = string
  })
}

#
# Deployment Fields
#

variable "architecture" {
  description = <<-EOF
Specify the deployment architecture, select from standalone or replication.
EOF
  type        = string
  default     = "standalone"
  validation {
    condition     = var.architecture == null || contains(["standalone", "replication"], var.architecture)
    error_message = "Invalid architecture"
  }
}

variable "replication_readonly_replicas" {
  description = <<-EOF
Specify the number of read-only replicas under the replication deployment.
EOF
  type        = number
  default     = 1
  validation {
    condition     = contains([1, 3, 5], var.replication_readonly_replicas)
    error_message = "Invalid number of read-only replicas"
  }
}

variable "engine_version" {
  description = <<-EOF
Specify the deployment engine version.
EOF
  type        = string
  default     = "5.0"
  validation {
    condition     = contains(["5.0", "4.0"], var.engine_version)
    error_message = "Invalid version"
  }
}

variable "engine_parameters" {
  description = <<-EOF
Specify the deployment parameters, see https://www.alibabacloud.com/help/zh/redis/user-guide/supported-parameters#concept-2087327.
EOF
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "password" {
  description = <<-EOF
Specify the account password.
EOF
  type        = string
  default     = null
  sensitive   = true
  validation {
    condition     = var.password == null || can(regex("^[A-Za-z0-9\\!#\\$%\\^&\\*\\(\\)_\\+\\-=]{16,32}", var.password))
    error_message = "Invalid password"
  }
}
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
  vpc_id: string, optional              # the ID of the VPC where the Redis service applies
  domain_suffix: string, optional       # a private DNS namespace of the PrivateZone where to register the applied Redis service
  publicly_accessible: bool, optional   # whether the Redis service is publicly accessible
```
EOF
  type = object({
    vpc_id              = optional(string)
    domain_suffix       = optional(string)
    publicly_accessible = optional(bool, false)
  })
  default = {
    publicly_accessible = false
  }
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
    condition     = var.architecture == "" || contains(["standalone", "replication"], var.architecture)
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
    condition     = var.replication_readonly_replicas == 0 || contains([1, 3, 5], var.replication_readonly_replicas)
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
    condition     = var.engine_version == "" || contains(["5.0", "4.0"], var.engine_version)
    error_message = "Invalid version"
  }
}

variable "password" {
  description = <<-EOF
Specify the account password. The password must be 16-32 characters long and start with any letter, number, or the following symbols: ! # $ % ^ & * ( ) _ + - =.
If not specified, it will generate a random password.
EOF
  type        = string
  default     = null
  sensitive   = true
  validation {
    condition     = var.password == null || var.password == "" || can(regex("^[A-Za-z0-9\\!#\\$%\\^&\\*\\(\\)_\\+\\-=]{16,32}", var.password))
    error_message = "Invalid password"
  }
}

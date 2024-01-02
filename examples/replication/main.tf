terraform {
  required_version = ">= 1.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1"
    }
    alicloud = {
      source  = "aliyun/alicloud"
      version = ">= 1.140.0"
    }
  }
}

data "alicloud_zones" "selected" {
  available_resource_creation = "KVStore"
}

# create vpc.

resource "alicloud_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "alicloud_vswitch" "example" {
  vpc_id     = alicloud_vpc.example.id
  zone_id    = data.alicloud_zones.selected.zones[0].id
  cidr_block = alicloud_vpc.example.cidr_block
}

# create redis service.

module "this" {
  source = "../.."

  infrastructure = {
    vpc_id = alicloud_vpc.example.id
  }

  architecture                  = "replication"
  replication_readonly_replicas = 3
}

output "context" {
  value = module.this.context
}

output "refer" {
  value = nonsensitive(module.this.refer)
}

output "connection" {
  value = module.this.connection
}

output "connection_readonly" {
  value = module.this.connection_readonly
}

output "address" {
  value = module.this.address
}

output "address_readonly" {
  value = module.this.address_readonly
}

output "port" {
  value = module.this.port
}

output "password" {
  value = nonsensitive(module.this.password)
}

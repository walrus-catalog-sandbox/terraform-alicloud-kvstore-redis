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
    vpc_id        = alicloud_vpc.example.id
    domain_suffix = "xxx"
  }

  architecture                  = "replication"
  replication_readonly_replicas = 3
}

output "context" {
  value = module.this.context
}

output "selector" {
  value = module.this.selector
}

output "endpoint_internal" {
  value = module.this.endpoint_internal
}

output "endpoint_internal_readonly" {
  value = module.this.endpoint_internal_readonly
}

output "password" {
  value = nonsensitive(module.this.password)
}
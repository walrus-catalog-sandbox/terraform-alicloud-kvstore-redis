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

# create private dns.

#data "alicloud_pvtz_service" "selected" {
#  enable = "On"
#}

resource "alicloud_pvtz_zone" "example" {
  zone_name = "my-dev-dns"

  #  depends_on = [data.alicloud_pvtz_service.selected]
}

resource "alicloud_pvtz_zone_attachment" "example" {
  zone_id = alicloud_pvtz_zone.example.id
  vpc_ids = [alicloud_vpc.example.id]
}

# create redis service.

module "this" {
  source = "../.."

  infrastructure = {
    vpc_id        = alicloud_vpc.example.id
    domain_suffix = alicloud_pvtz_zone.example.zone_name
  }

  architecture = "standalone"
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

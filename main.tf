locals {
  project_name     = coalesce(try(var.context["project"]["name"], null), "default")
  project_id       = coalesce(try(var.context["project"]["id"], null), "default_id")
  environment_name = coalesce(try(var.context["environment"]["name"], null), "test")
  environment_id   = coalesce(try(var.context["environment"]["id"], null), "test_id")
  resource_name    = coalesce(try(var.context["resource"]["name"], null), "example")
  resource_id      = coalesce(try(var.context["resource"]["id"], null), "example_id")

  namespace = join("-", [local.project_name, local.environment_name])

  tags = {
    "Name" = join("-", [local.namespace, local.resource_name])

    "walrus.seal.io/catalog-name"     = "terraform-alicloud-kvstore-redis"
    "walrus.seal.io/project-id"       = local.project_id
    "walrus.seal.io/environment-id"   = local.environment_id
    "walrus.seal.io/resource-id"      = local.resource_id
    "walrus.seal.io/project-name"     = local.project_name
    "walrus.seal.io/environment-name" = local.environment_name
    "walrus.seal.io/resource-name"    = local.resource_name
  }

  architecture = coalesce(var.architecture, "standalone")
}

# create vpc.

resource "alicloud_vpc" "default" {
  count = var.infrastructure.vpc_id == null ? 1 : 0

  vpc_name    = "default"
  cidr_block  = "10.0.0.0/16"
  description = "default"
}

resource "alicloud_vswitch" "default" {
  for_each = var.infrastructure.vpc_id == null ? {
    for i, c in data.alicloud_zones.selected.ids : c => cidrsubnet(alicloud_vpc.default[0].cidr_block, 8, i)
  } : {}

  vpc_id      = alicloud_vpc.default[0].id
  zone_id     = each.key
  cidr_block  = each.value
  description = "default"

  depends_on = [data.alicloud_zones.selected]
}

#
# Ensure
#

data "alicloud_vpcs" "selected" {
  ids = [var.infrastructure.vpc_id != null ? var.infrastructure.vpc_id : alicloud_vpc.default[0].id]

  status = "Available"

  lifecycle {
    postcondition {
      condition     = length(self.ids) == 1
      error_message = "Failed to get available VPC"
    }
  }

  depends_on = [alicloud_vpc.default]
}

data "alicloud_vswitches" "selected" {
  vpc_id = data.alicloud_vpcs.selected.ids[0]

  lifecycle {
    postcondition {
      condition     = local.architecture == "replication" ? length(self.ids) > 1 : length(self.ids) > 0
      error_message = "Failed to get available VSwitch"
    }
  }

  depends_on = [alicloud_vswitch.default]
}

data "alicloud_pvtz_zones" "selected" {
  count = var.infrastructure.domain_suffix == null ? 0 : 1

  keyword     = var.infrastructure.domain_suffix
  search_mode = "EXACT"

  lifecycle {
    postcondition {
      condition     = length(self.ids) == 1
      error_message = "Failed to get available private zone"
    }
  }
}

data "alicloud_zones" "selected" {
  available_resource_creation = "KVStore"

  lifecycle {
    postcondition {
      condition     = length(self.ids) > 0
      error_message = "VPC needs multiple zones distributed in different VSwitches"
    }
  }
}

#
# Random
#

# create a random password for blank password input.

resource "random_password" "password" {
  length      = 16
  special     = false
  lower       = true
  min_lower   = 3
  min_upper   = 3
  min_numeric = 3
}

# create the name with a random suffix.

resource "random_string" "name_suffix" {
  length  = 10
  special = false
  upper   = false
}


locals {
  name     = join("-", [local.resource_name, random_string.name_suffix.result])
  fullname = format("walrus-%s", md5(join("-", [local.namespace, local.name])))
  password = coalesce(var.password, random_password.password.result)

  replication_readonly_replicas = var.replication_readonly_replicas == 0 ? 1 : var.replication_readonly_replicas
}

#
# Deployment
#

locals {
  version = coalesce(var.engine_version, "5.0")
  node_type_map = {
    1 = "readone"
    3 = "readthree"
    5 = "readfive"
  }
  publicly_accessible = try(var.infrastructure.publicly_accessible, false)
}

locals {
  zones = setintersection(data.alicloud_zones.selected.ids, data.alicloud_vswitches.selected.vswitches[*].zone_id)
  vswitch_zone_map = {
    for v in data.alicloud_vswitches.selected.vswitches : v.id => v.zone_id
    if contains(local.zones, v.zone_id)
  }
  vswitches = keys(local.vswitch_zone_map)
}

data "alicloud_kvstore_instance_classes" "selected" {
  engine               = "Redis"
  engine_version       = local.version
  zone_id              = local.vswitch_zone_map[local.vswitches[0]]
  architecture         = local.architecture == "replication" ? "rwsplit" : "standard"
  node_type            = local.architecture == "replication" ? local.node_type_map[local.replication_readonly_replicas] : null
  instance_charge_type = "PostPaid"
}

resource "alicloud_kvstore_instance" "default" {
  db_instance_name = local.fullname
  tags             = local.tags

  vswitch_id   = local.vswitches[0]
  zone_id      = local.vswitch_zone_map[local.vswitches[0]]
  security_ips = local.publicly_accessible ? ["0.0.0.0/0", data.alicloud_vpcs.selected.vpcs[0].cidr_block] : [data.alicloud_vpcs.selected.vpcs[0].cidr_block]

  engine_version = local.version
  password       = local.password

  instance_type  = "Redis"
  instance_class = data.alicloud_kvstore_instance_classes.selected.instance_classes[0]

  lifecycle {
    ignore_changes = [
      password
    ]
  }

  depends_on = [alicloud_vswitch.default]
}

#
# Exposing
#

resource "alicloud_kvstore_connection" "default" {
  count = local.publicly_accessible ? 1 : 0

  connection_string_prefix = format("%stf", alicloud_kvstore_instance.default.id)
  instance_id              = alicloud_kvstore_instance.default.id
  port                     = local.port
}

resource "alicloud_pvtz_zone_record" "default" {
  count = var.infrastructure.domain_suffix == null ? 0 : 1

  zone_id = data.alicloud_pvtz_zones.selected[0].ids[0]

  type  = "CNAME"
  rr    = format("%s.%s", local.name, local.namespace)
  value = alicloud_kvstore_instance.default.connection_domain
  ttl   = 30
}

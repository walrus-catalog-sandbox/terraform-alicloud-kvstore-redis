output "context" {
  description = "The input context, a map, which is used for orchestration."
  value       = var.context
}

output "selector" {
  description = "The selector, a map, which is used for dependencies or collaborations."
  value       = local.tags
}

output "endpoint_internal" {
  description = "The internal endpoints, a string list, which are used for internal access."
  value       = format("%s.%s:6379", alicloud_pvtz_zone_record.default.rr, var.infrastructure.domain_suffix)
}

output "endpoint_internal_readonly" {
  description = "The internal readonly endpoints, a string list, which are used for internal readonly access."
  value       = format("%s.%s:6379", alicloud_pvtz_zone_record.default.rr, var.infrastructure.domain_suffix)
}

output "password" {
  value       = local.password
  sensitive   = true
  description = "The password of redis service."
}
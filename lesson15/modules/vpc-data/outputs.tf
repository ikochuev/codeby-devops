output "subnets_by_zone" {
  description = "Subnets grouped by zone"
  value       = local.subnets_by_zone
}

output "all_subnets" {
  description = "List of all subnet objects"
  value       = local.all_subnets_list
}

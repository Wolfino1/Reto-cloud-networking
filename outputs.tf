output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

output "subnet_ids" {
  description = "Map of subnet IDs by group-index (e.g. public-0, private-1)"
  value = {
    for k, v in aws_subnet.subnet : k => v.id
  }
}

output "route_table_ids" {
  description = "Map of route table IDs by group (public, private, service, database)"
  value = {
    for k, v in aws_route_table.route_table : k => v.id
  }
}

output "load_balancer_dns_name" {
  value = aws_lb.load_balancer.dns_name
  description = "The DNS name of the load balancer."
}

output "public_dns" {
  value = zipmap(aws_instance.instance[*].tags["Name"], aws_eip.web_eip[*].public_dns)
}

output "instance_ip_map" {
  value = zipmap(aws_instance.instance[*].tags["Name"], aws_eip.web_eip[*].public_ip)
  description = "Map of instance names to their public IP addresses."
}

output "database_port" {
  value       = var.db_exists ? data.aws_db_instance.existing_db[0].port : (length(aws_db_instance.db_instance) > 0 ? aws_db_instance.db_instance[0].port : 0)
  description = "The database port for db"
}

output "database_endpoint" {
  value       = var.db_exists ? data.aws_db_instance.existing_db[0].endpoint : (length(aws_db_instance.db_instance) > 0 ? aws_db_instance.db_instance[0].endpoint : "")
  description = "The database endpoint for db"
}

output "database_name" {
  value       = var.db_exists ? data.aws_db_instance.existing_db[0].db_name : (length(aws_db_instance.db_instance) > 0 ? aws_db_instance.db_instance[0].db_name : "")
  description = "The database name for db"
}

output "vpc_id" {
    value = aws_vpc.vpc.id
}

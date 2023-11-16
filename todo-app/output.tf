output "dns_address" {
  value = module.todo_app.load_balancer_dns_name
}

output "instance_ip_map" {
  value = module.todo_app.instance_ip_map
}

output "public_dns" {
  value = module.todo_app.public_dns
}

output "database_endpoint" {
  value = module.todo_app.database_endpoint
}

output "database_port" {
  value = module.todo_app.database_port
}

output "database_name" {
  value = module.todo_app.database_name
}

output "vpc_id" {
  value = module.todo_app.vpc_id
}

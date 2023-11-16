locals {
  database_host = var.db_exists ? data.aws_db_instance.existing_db[0].endpoint : (length(aws_db_instance.db_instance) > 0 ? aws_db_instance.db_instance[0].endpoint : "")
  database_port = var.db_exists ? data.aws_db_instance.existing_db[0].port : (length(aws_db_instance.db_instance) > 0 ? aws_db_instance.db_instance[0].port : 0)
  database_name = var.database_name
  database_user = var.database_user
  database_pass = var.database_pass
  bucket_name   = var.bucket_name
}

data "template_file" "init_script" {
  template = file("../todo-app-modules/ubuntu-config.sh")
  
  vars = {
    database_host = local.database_host
    database_port = local.database_port
    database_name = local.database_name
    database_user = local.database_user
    database_pass = local.database_pass
    bucket_name   = local.bucket_name
  }
}

resource "local_file" "env_file" {
  filename = "../resources/env.${var.environment}"
  content           = jsonencode (
    {
      database_host   = local.database_host
      database_port   = local.database_port
      database_name   = local.database_name
      database_user   = local.database_user
      database_pass   = local.database_pass
      dns_address     = aws_lb.load_balancer.dns_name
      instance_ip_map = zipmap(aws_instance.instance[*].tags["Name"], aws_eip.web_eip[*].public_ip)
      environment     = var.environment
    }
  )
}

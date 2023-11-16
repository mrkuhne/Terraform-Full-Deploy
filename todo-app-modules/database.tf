data "aws_db_instance" "existing_db" {
    count                       = var.db_exists ? 1 : 0
    db_instance_identifier      = "${var.environment}-database"
}

resource "aws_db_instance" "db_instance" {
    count                       = var.db_exists ? 0 : 1
    engine                      = "mysql"
    engine_version              = "8.0.33"
    allocated_storage           = 10
    storage_type                = "gp2"
    db_name                     = "${var.database_name}"
    identifier                  = "${var.environment}-database"
    username                    = "${var.database_user}"
    password                    = "${var.database_pass}"
    instance_class              = "db.t3.micro"
    skip_final_snapshot         = true
    vpc_security_group_ids      = [aws_security_group.db_security.id]
    db_subnet_group_name        =  aws_db_subnet_group.db_subnet_group.id

    lifecycle {
        ignore_changes          = all
    }
}
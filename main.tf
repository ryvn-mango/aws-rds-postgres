resource "random_pet" "this" {
  length    = 2
  separator = "-"
  prefix    = "postgres"
}

data "aws_rds_orderable_db_instance" "postgres" {
  engine         = "postgres"
  license_model  = "postgresql-license"
  storage_type   = var.storage_type
  preferred_instance_classes = [var.instance_class]
  preferred_engine_versions  = [var.engine_version, "15.2", "14.7"]  # Fallback versions if specified version isn't available
}

resource "aws_db_subnet_group" "this" {
  name       = random_pet.this.id
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "aws_security_group" "this" {
  name        = "${random_pet.this.id}-rds-sg"
  description = "Security group for ${random_pet.this.id} RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_db_instance" "this" {
  identifier = random_pet.this.id

  engine         = data.aws_rds_orderable_db_instance.postgres.engine
  engine_version = data.aws_rds_orderable_db_instance.postgres.engine_version
  instance_class = data.aws_rds_orderable_db_instance.postgres.instance_class

  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted

  db_name  = var.database_name
  username = var.username
  password = var.password
  port     = 5432

  multi_az               = var.multi_az
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  skip_final_snapshot = var.skip_final_snapshot

  tags = var.tags
}

locals {
  password = "init-secret-pass"
  name     = "db-test-123"
}

# aws_db_instance.default
resource "aws_db_instance" "default" {
  identifier                            = local.name
  allocated_storage                     = 20
  auto_minor_version_upgrade            = true
  availability_zone                     = "us-west-2d"
  backup_retention_period               = 7
  backup_window                         = "08:48-09:18"
  ca_cert_identifier                    = "rds-ca-2019"
  copy_tags_to_snapshot                 = true
  customer_owned_ip_enabled             = false
  db_subnet_group_name                  = "default-vpc-02e49367b867d4b8f"
  delete_automated_backups              = true
  deletion_protection                   = false
  enabled_cloudwatch_logs_exports       = []
  engine                                = "postgres"
  engine_version                        = "14.2"
  iam_database_authentication_enabled   = false
  instance_class                        = "db.t3.micro"
  iops                                  = 0
  kms_key_id                            = "arn:aws:kms:us-west-2:050072676240:key/70e56086-4c7b-4d99-9b36-de4d673b315d"
  license_model                         = "postgresql-license"
  maintenance_window                    = "sun:09:25-sun:09:55"
  max_allocated_storage                 = 1000
  monitoring_interval                   = 0
  multi_az                              = false
  option_group_name                     = "default:postgres-14"
  parameter_group_name                  = "default.postgres14"
  performance_insights_enabled          = true
  performance_insights_kms_key_id       = "arn:aws:kms:us-west-2:050072676240:key/70e56086-4c7b-4d99-9b36-de4d673b315d"
  performance_insights_retention_period = 7
  port                                  = 5432
  publicly_accessible                   = true
  security_group_names                  = []
  skip_final_snapshot                   = true
  storage_encrypted                     = true
  storage_type                          = "gp2"
  tags                                  = {}
  tags_all                              = {}
  username                              = "postgres"
  password                              = local.password
  vpc_security_group_ids = [
    "sg-04983a985d3c3b436",
  ]

  timeouts {}
}

module "secrets_rotator" {
  source = "./secret_rotator"

  account_id    = "050072676240"
  function_name = local.name
  region        = "us-west-2"
}

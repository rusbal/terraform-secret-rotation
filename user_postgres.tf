# aws_secretsmanager_secret.db:
resource "aws_secretsmanager_secret" "db" {
  name = "postgres-password-generated"
}

# aws_secretsmanager_secret_version.version:
resource "aws_secretsmanager_secret_version" "version" {
  secret_id = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    username : "postgres",
    password : local.password,
    engine : aws_db_instance.default.engine,
    host : aws_db_instance.default.address,
    port : aws_db_instance.default.port,
    dbInstanceIdentifier : aws_db_instance.default.identifier,
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

# aws_secretsmanager_secret_rotation.db:
resource "aws_secretsmanager_secret_rotation" "db" {
  secret_id           = aws_secretsmanager_secret.db.id
  rotation_lambda_arn = module.secrets_rotator.arn

  rotation_rules {
    automatically_after_days = 30
  }
}

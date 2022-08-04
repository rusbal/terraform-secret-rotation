# aws_secretsmanager_secret.raymond:
resource "aws_secretsmanager_secret" "raymond" {
  name     = "raymond-password-generated"
}

# aws_secretsmanager_secret_version.version:
resource "aws_secretsmanager_secret_version" "raymond" {
  secret_id = aws_secretsmanager_secret.raymond.id
  secret_string = jsonencode({
    username : "raymond",
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

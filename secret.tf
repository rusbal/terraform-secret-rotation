# aws_secretsmanager_secret.db:
resource "aws_secretsmanager_secret" "db" {
  name     = "postgres-password"
  tags     = {}
  tags_all = {}
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
  rotation_lambda_arn = aws_lambda_function.secret.arn
  secret_id           = aws_secretsmanager_secret.db.id

  rotation_rules {
    automatically_after_days = 30
  }
}

# aws_lambda_function.secret:
resource "aws_lambda_function" "secret" {
  description      = "Rotates a Secrets Manager secret for Amazon RDS PostgreSQL credentials using the single user rotation strategy."
  function_name    = "aws_lambda_function_db"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.7"
  role             = aws_iam_role.lambda.arn
  source_code_hash = filebase64sha256("lambda.zip")
  timeout          = 30
  filename         = "lambda.zip"

  environment {
    variables = {
      "EXCLUDE_CHARACTERS"       = ":/@\"'\\"
      "SECRETS_MANAGER_ENDPOINT" = "https://secretsmanager.us-west-2.amazonaws.com"
    }
  }
}

resource "aws_lambda_permission" "allow_secret_manager_call_lambda" {
  function_name = aws_lambda_function.secret.function_name
  statement_id  = "AllowExecutionSecretManager"
  action        = "lambda:InvokeFunction"
  principal     = "secretsmanager.amazonaws.com"
}

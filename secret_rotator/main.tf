# data.archive_file.lambda:
data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/source"
  output_path = "${path.module}/lambda/source.zip"
}

# aws_lambda_function.secret:
resource "aws_lambda_function" "secret" {
  function_name    = var.function_name
  description      = "Rotates a Secrets Manager secret for Amazon RDS PostgreSQL credentials using the single user rotation strategy."
  handler          = "lambda_function.lambda_handler"
  architectures    = ["x86_64"]
  runtime          = "python3.7"
  timeout          = 30
  source_code_hash = filebase64sha256(data.archive_file.lambda.output_path)
  filename         = data.archive_file.lambda.output_path
  role             = aws_iam_role.lambda.arn

  environment {
    variables = {
      "EXCLUDE_CHARACTERS"       = ":/@\"'\\"
      "SECRETS_MANAGER_ENDPOINT" = "https://secretsmanager.${var.region}.amazonaws.com"
    }
  }
}

resource "aws_lambda_permission" "allow_secret_manager_call_lambda" {
  function_name = aws_lambda_function.secret.function_name
  statement_id  = "AllowExecutionSecretManager"
  action        = "lambda:InvokeFunction"
  principal     = "secretsmanager.amazonaws.com"
}

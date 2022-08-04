# aws_iam_role.lambda:
resource "aws_iam_role" "lambda" {
  name = "${var.function_name}_aws_iam_role"
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "lambda.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  force_detach_policies = false
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
  ]
  max_session_duration = 3600
  path                 = "/"

  inline_policy {
    name = "SecretsManagerRDSPostgreSQLRotationSingleUserRolePolicy0-${var.function_name}"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "ec2:CreateNetworkInterface",
              "ec2:DeleteNetworkInterface",
              "ec2:DescribeNetworkInterfaces",
              "ec2:DetachNetworkInterface",
            ]
            Effect   = "Allow"
            Resource = "*"
          },
        ]
      }
    )
  }
  inline_policy {
    name = "SecretsManagerRDSPostgreSQLRotationSingleUserRolePolicy1-${var.function_name}"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "secretsmanager:DescribeSecret",
              "secretsmanager:GetSecretValue",
              "secretsmanager:PutSecretValue",
              "secretsmanager:UpdateSecretVersionStage",
            ]
            Effect   = "Allow"
            Resource = "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:*"
          },
          {
            Action = [
              "secretsmanager:GetRandomPassword",
            ]
            Effect   = "Allow"
            Resource = "*"
          },
        ]
      }
    )
  }
}

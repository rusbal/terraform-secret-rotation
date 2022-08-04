# aws_lambda_function.db:
resource "aws_lambda_function" "db" {
  architectures                  = ["x86_64"]
  description                    = "Rotates a Secrets Manager secret for Amazon RDS PostgreSQL credentials using the single user rotation strategy."
  function_name                  = "arn:aws:lambda:us-west-2:050072676240:function:SecretsManagerpostgres-rotation-lambda"
  handler                        = "lambda_function.lambda_handler"
  layers                         = []
  memory_size                    = 128
  package_type                   = "Zip"
  reserved_concurrent_executions = -1
  role                           = aws_iam_role.lambda.arn
  runtime                        = "python3.7"
  source_code_hash               = "XjmHzGU8aSHkS27BBAI4VZqX+aS2v8ObY2biY4nXKZU="
  tags = {
    "SecretsManagerLambda" = "Rotation"
    "lambda:createdBy"     = "SAM"
  }
  tags_all = {
    "SecretsManagerLambda" = "Rotation"
    "lambda:createdBy"     = "SAM"
  }
  timeout = 30

  environment {
    variables = {
      "EXCLUDE_CHARACTERS"       = ":/@\"'\\"
      "SECRETS_MANAGER_ENDPOINT" = "https://secretsmanager.us-west-2.amazonaws.com"
    }
  }

  ephemeral_storage {
    size = 512
  }

  timeouts {}

  tracing_config {
    mode = "PassThrough"
  }
}

# aws_iam_role.lambda:
resource "aws_iam_role" "lambda" {
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
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "secretsmanager.amazonaws.com"
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
  name                 = "SecretsManagerRDSPostgreS-SecretsManagerRDSPostgre-1ROSS4UUXCVRJ"
  path                 = "/"
  tags = {
    "SecretsManagerLambda" = "Rotation"
    "lambda:createdBy"     = "SAM"
  }
  tags_all = {
    "SecretsManagerLambda" = "Rotation"
    "lambda:createdBy"     = "SAM"
  }

  inline_policy {
    name = "SecretsManagerRDSPostgreSQLRotationSingleUserRolePolicy0"
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
    name = "SecretsManagerRDSPostgreSQLRotationSingleUserRolePolicy1"
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
            Condition = {
              StringEquals = {
                "secretsmanager:resource/AllowRotationLambdaArn" = "arn:aws:lambda:us-west-2:050072676240:function:SecretsManagerpostgres-rotation-lambda"
              }
            }
            Effect   = "Allow"
            Resource = "arn:aws:secretsmanager:us-west-2:050072676240:secret:*"
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

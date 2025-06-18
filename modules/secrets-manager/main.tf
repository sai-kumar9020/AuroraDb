resource "random_password" "db_password" {
  length  = var.password_length
  special = true
  upper   = true
  lower   = true
  numeric = true
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = var.secret_name
  description             = var.secret_description
  recovery_window_in_days = var.recovery_window_in_days
  
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.username
    password = random_password.db_password.result
  })
}

# Create IAM policy for accessing the secret
resource "aws_iam_policy" "secrets_access" {
  count = var.create_access_policy ? 1 : 0
  
  name        = "${var.secret_name}-access-policy"
  description = "Policy to access database credentials secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret.db_credentials.arn
      }
    ]
  })

  tags = var.tags
}
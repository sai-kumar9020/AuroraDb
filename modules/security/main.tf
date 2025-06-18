# Security group for Aurora cluster
resource "aws_security_group" "aurora" {
  name_prefix = "${var.name_prefix}-aurora-"
  vpc_id      = var.vpc_id
  description = "Security group for Aurora database cluster"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-aurora-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Ingress rules for Aurora
resource "aws_security_group_rule" "aurora_ingress" {
  count = length(var.allowed_cidr_blocks) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = var.database_port
  to_port           = var.database_port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = aws_security_group.aurora.id
  description       = "Allow database access from specified CIDR blocks"
}

# Ingress rules for Aurora from security groups
resource "aws_security_group_rule" "aurora_ingress_sg" {
  count = length(var.allowed_security_groups)

  type                     = "ingress"
  from_port                = var.database_port
  to_port                  = var.database_port
  protocol                 = "tcp"
  source_security_group_id = var.allowed_security_groups[count.index]
  security_group_id        = aws_security_group.aurora.id
  description              = "Allow database access from security group ${var.allowed_security_groups[count.index]}"
}

# Egress rule for Aurora (allow all outbound traffic)
resource "aws_security_group_rule" "aurora_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aurora.id
  description       = "Allow all outbound traffic"
}

# IAM role for enhanced monitoring
resource "aws_iam_role" "enhanced_monitoring" {
  count = var.create_monitoring_role ? 1 : 0
  
  name_prefix        = "${var.name_prefix}-aurora-monitoring-"
  assume_role_policy = data.aws_iam_policy_document.enhanced_monitoring[0].json

  tags = var.tags
}

data "aws_iam_policy_document" "enhanced_monitoring" {
  count = var.create_monitoring_role ? 1 : 0
  
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  count = var.create_monitoring_role ? 1 : 0
  
  role       = aws_iam_role.enhanced_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}


resource "aws_kms_key" "aurora" {
  count = var.create_kms_key ? 1 : 0
  
  description             = "KMS key for Aurora cluster encryption"
  deletion_window_in_days = var.kms_key_deletion_window
  enable_key_rotation     = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-aurora-kms-key"
  })
}

resource "aws_kms_alias" "aurora" {
  count = var.create_kms_key ? 1 : 0
  
  name          = "alias/${var.name_prefix}-aurora"
  target_key_id = aws_kms_key.aurora[0].key_id
}
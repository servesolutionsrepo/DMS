resource "aws_iam_role" "ec2_instance_role" {
  name = "ec2_instance_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "dms.amazonaws.com"
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "rds.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "aws assume role"
      Environment = var.environment
    },
  )
}


resource "aws_iam_policy" "policy" {
  name        = "ec2_instance_policy"
  description = "Policy for EC2, DMS, RDS, KMS, and CloudWatch"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # EC2 Permissions
      {
        Action = [
          "ec2:Describe*",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      # RDS Permissions (Read/Write and Snapshot Access)
      {
        Action = [
          "rds:DescribeDBInstances",
          "rds:DescribeDBSnapshots",
          "rds:ModifyDBInstance",
          "rds:CreateDBSnapshot",
          "rds:DeleteDBSnapshot",
          "rds:RestoreDBInstanceFromDBSnapshot",
          "rds:StartDBInstance",
          "rds:StopDBInstance"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      # KMS Permissions (For encrypted DB instances and snapshots)
      {
        Action = [
          "kms:ListAliases",
          "kms:DescribeKey",
          "kms:Decrypt"
        ]
        Effect   = "Allow"
        Resource = "*"  # Or specify the KMS key ARN(s)
      },
      # CloudWatch Logs Permissions (Monitoring and logging)
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      # S3 Permissions (Optional - For data migration)
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "aws assume policy"
      Environment = var.environment
    },
  )
}


resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "ip" {
  name = "aws_instance_profile_test"
  role = aws_iam_role.ec2_instance_role.name

  tags = merge(
    var.tags,
    {
      Name = "aws assume role"
    },
  )
}

data "aws_iam_policy_document" "dms_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["dms.amazonaws.com"]
      type        = "Service"
    }
  }

  statement {
    actions   = ["*"]
    resources = ["*"]
  }
}
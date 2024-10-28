# AWS DMS Source Endpoint
resource "aws_dms_endpoint" "source" {
  certificate_arn = aws_dms_certificate.test.certificate_arn
  database_name   = var.dms_endpoint.database_name
  endpoint_id     = var.dms_endpoint.endpoint_id
  endpoint_type   = var.dms_endpoint.endpoint_type
  engine_name     = var.dms_endpoint.engine_name
  password        = var.dms_endpoint.password  # Secure this!
  port            = var.dms_endpoint.port
  server_name     = var.dms_endpoint.server_name
  ssl_mode        = var.dms_endpoint.ssl_mode

  tags = {
    Name = "test"
  }

  username = "test"
}

# AWS DMS S3 Target Endpoint
resource "aws_dms_s3_endpoint" "target" {
  endpoint_id   = var.dms_s3_endpoint.endpoint_id
  endpoint_type = var.dms_s3_endpoint.endpoint_type
  ssl_mode      = var.dms_s3_endpoint.ssl_mode

  tags = var.dms_s3_endpoint.tags
}

data "aws_secretsmanager_secret_version" "dms_cert" {
  secret_id = "arn:aws:secretsmanager:us-east-1:123456789012:secret:test-dms-certificate"
}

# AWS DMS Certificate
resource "aws_dms_certificate" "test" {
  certificate_id  = "test-dms-certificate-tf"
  certificate_pem = data.aws_secretsmanager_secret_version.dms_cert.secret_string
  # Secure this!

  tags = {
    Name = "test"
  }
}

# AWS DMS Replication Instance
resource "aws_dms_replication_instance" "test" {
  allocated_storage            = var.dms_replication_instance.allocated_storage
  apply_immediately            = var.dms_replication_instance.apply_immediately
  auto_minor_version_upgrade   = var.dms_replication_instance.auto_minor_version_upgrade
  availability_zone            = var.dms_replication_instance.availability_zone
  engine_version               = var.dms_replication_instance.engine_version
  multi_az                     = var.dms_replication_instance.multi_az
  preferred_maintenance_window = var.dms_replication_instance.preferred_maintenance_window
  publicly_accessible          = var.dms_replication_instance.publicly_accessible
  replication_instance_class   = var.dms_replication_instance.replication_instance_class
  replication_instance_id      = var.dms_replication_instance.replication_instance_id
  allow_major_version_upgrade  = var.dms_replication_instance.allow_major_version_upgrade

  tags = var.dms_replication_instance.tags

  vpc_security_group_ids = var.dms_replication_instance.vpc_security_group_ids

  depends_on = [
    aws_iam_role_policy_attachment.dms-access-for-endpoint-AmazonDMSRedshiftS3Role,
    aws_iam_role_policy_attachment.dms-cloudwatch-logs-role-AmazonDMSCloudWatchLogsRole,
    aws_iam_role_policy_attachment.dms-vpc-role-AmazonDMSVPCManagementRole
  ]
}

# AWS DMS Replication Task
resource "aws_dms_replication_task" "test" {
  cdc_start_time            = var.dms_replication_task.cdc_start_time
  migration_type            = var.dms_replication_task.migration_type
  replication_instance_arn  = var.dms_replication_task.replication_instance_arn
  replication_task_id       = var.dms_replication_task.replication_task_id
  replication_task_settings = var.dms_replication_task.replication_task_settings
  source_endpoint_arn       = var.dms_replication_task.source_endpoint_arn
  table_mappings            = var.dms_replication_task.table_mappings

  tags = var.dms_replication_task.tags

  target_endpoint_arn = var.dms_replication_task.target_endpoint_arn
}

# AWS DMS Event Subscription
resource "aws_dms_event_subscription" "example" {
  enabled          = var.dms_event_subscription.enabled
  event_categories = var.dms_event_subscription.event_categories
  name             = var.dms_event_subscription.name
  sns_topic_arn    = var.dms_event_subscription.sns_topic_arn
  #source_ids       = var.dms_event_subscription.source_ids
  source_type      = var.dms_event_subscription.source_type

  tags = var.dms_event_subscription.tags
}

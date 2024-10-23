# AWS DMS Source Endpoint
resource "aws_dms_endpoint" "source" {
  certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  database_name   = "test"
  endpoint_id     = "test-dms-endpoint-tf"
  endpoint_type   = "source"
  engine_name     = "aurora"
  password        = "test"  # Secure this!
  port            = 3306
  server_name     = "test"
  ssl_mode        = "none"

  tags = {
    Name = "test"
  }

  username = "test"
}

# AWS DMS S3 Target Endpoint
resource "aws_dms_s3_endpoint" "target" {
  endpoint_id   = "donnedtipi"
  endpoint_type = "target"
  ssl_mode      = "none"

  tags = {
    Name   = "donnedtipi"
    Update = "to-update"
    Remove = "to-remove"
  }
}

# AWS DMS Certificate
resource "aws_dms_certificate" "test" {
  certificate_id  = "test-dms-certificate-tf"
  certificate_pem = "..."  # Secure this!

  tags = {
    Name = "test"
  }
}

# AWS DMS Replication Instance
resource "aws_dms_replication_instance" "test" {
  allocated_storage            = 20
  apply_immediately            = true
  auto_minor_version_upgrade   = true
  availability_zone            = "us-west-2c"
  engine_version               = "3.1.4"
  kms_key_arn                  = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-123456789012"
  multi_az                     = false
  preferred_maintenance_window = "sun:10:30-sun:14:30"
  publicly_accessible          = true
  replication_instance_class   = "dms.t2.micro"
  replication_instance_id      = "test-dms-replication-instance-tf"
  allow_major_version_upgrade  = true

  tags = {
    Name = "test"
  }

  vpc_security_group_ids = [
    "sg-12345678",
  ]

  depends_on = [
    aws_iam_role_policy_attachment.dms-access-for-endpoint-AmazonDMSRedshiftS3Role,
    aws_iam_role_policy_attachment.dms-cloudwatch-logs-role-AmazonDMSCloudWatchLogsRole,
    aws_iam_role_policy_attachment.dms-vpc-role-AmazonDMSVPCManagementRole
  ]
}

# AWS DMS Replication Task
resource "aws_dms_replication_task" "test" {
  cdc_start_time            = "1993-05-21T05:50:00Z"
  migration_type            = "full-load"
  replication_instance_arn  = aws_dms_replication_instance.test.replication_instance_arn
  replication_task_id       = "test-dms-replication-task-tf"
  replication_task_settings = "..."
  source_endpoint_arn       = aws_dms_endpoint.source.endpoint_arn
  table_mappings            = "{\"rules\":[{\"rule-type\":\"selection\",\"rule-id\":\"1\",\"rule-name\":\"1\",\"object-locator\":{\"schema-name\":\"%\",\"table-name\":\"%\"},\"rule-action\":\"include\"}]}"

  tags = {
    Name = "test"
  }

  target_endpoint_arn = aws_dms_s3_endpoint.target.endpoint_arn
}

resource "aws_dms_replication_task" "full_load" {
  replication_task_id          = "full-load-task"
  replication_instance_arn     = aws_dms_replication_instance.main.replication_instance_arn
  source_endpoint_arn          = aws_dms_endpoint.source.endpoint_arn
  target_endpoint_arn          = aws_dms_endpoint.destination.endpoint_arn
  migration_type               = "full-load"
}

resource "aws_dms_replication_task" "cdc" {
  replication_task_id          = "cdc-task"
  replication_instance_arn     = aws_dms_replication_instance.main.replication_instance_arn
  source_endpoint_arn          = aws_dms_endpoint.source.endpoint_arn
  target_endpoint_arn          = aws_dms_endpoint.destination.endpoint_arn
  migration_type               = "cdc"
}



# AWS DMS Event Subscription
resource "aws_dms_event_subscription" "example" {
  enabled          = true
  event_categories = ["creation", "failure"]
  name             = "my-favorite-event-subscription"
  sns_topic_arn    = aws_sns_topic.example.arn
  source_ids       = [aws_dms_replication_task.test.replication_task_id]
  source_type      = "replication-task"

  tags = {
    Name = "example"
  }
}

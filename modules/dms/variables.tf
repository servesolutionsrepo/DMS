
variable "dms_endpoint" {
  description = "Configuration for the DMS endpoint"
  type = object({
    endpoint_id   = string
    endpoint_type = string
    engine_name   = string
    username      = string
    password      = string
    server_name   = string
    port          = number
    database_name = string
    ssl_mode      = string
    tags          = map(string)
  })
  default = {
    endpoint_id   = "donnedtipi"
    endpoint_type = "source"
    engine_name   = "sqlserver"
    username      = "admin"
    password      = "password"
    server_name   = "donnedtipi.database.windows.net"
    port          = 3306
    database_name = "test"
    ssl_mode      = "none"
    tags = {
      Name   = "donnedtipi"
      Update = "to-update"
      Remove = "to-remove"
    }
  }
}

variable "aws_dms_s3_endpoint" {
  description = "Configuration for the DMS S3 endpoint"
  type = object({
    endpoint_id   = string
    endpoint_type = string
    ssl_mode      = string
    tags          = map(string)
  })
  default = {
    endpoint_id   = "donnedtipi"
    endpoint_type = "target"
    ssl_mode      = "none"
    tags = {
      Name   = "donnedtipi"
      Update = "to-update"
      Remove = "to-remove"
    }
  }
}

variable "dms_replication_instance" {
  description = "Configuration for the DMS replication instance"
  type = object({
    allocated_storage            = number
    apply_immediately            = bool
    auto_minor_version_upgrade   = bool
    availability_zone            = string
    engine_version               = string
    multi_az                     = bool
    preferred_maintenance_window = string
    publicly_accessible          = bool
    replication_instance_class   = string
    replication_instance_id      = string
    allow_major_version_upgrade  = bool
    tags                         = map(string)
    vpc_security_group_ids       = list(string)
    depends_on                   = list(string)
  })
  default = {
    allocated_storage            = 20
    apply_immediately            = true
    auto_minor_version_upgrade   = true
    availability_zone            = "eu-west-2a"
    engine_version               = "3.1.4"
    multi_az                     = false
    preferred_maintenance_window = "sun:10:30-sun:14:30"
    publicly_accessible          = false
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
      "aws_iam_role_policy_attachment.dms-access-for-endpoint-AmazonDMSRedshiftS3Role",
      "aws_iam_role_policy_attachment.dms-cloudwatch-logs-role-AmazonDMSCloudWatchLogsRole",
      "aws_iam_role_policy_attachment.dms-vpc-role-AmazonDMSVPCManagementRole"
    ]
  }
}

variable "dms_replication_task" {
  description = "Configuration for the DMS replication task"
  type = object({
    cdc_start_time            = string
    migration_type            = string
    #replication_instance_arn  = string
    replication_task_id       = string
    replication_task_settings = string
    table_mappings            = string
    tags                      = map(string)
  })
  default = {
    cdc_start_time            = "1993-05-21T05:50:00Z"
    migration_type            = "full-load"
    replication_task_id       = "test-dms-replication-task-tf"
    replication_task_settings = "..."
    table_mappings            = "{\"rules\":[{\"rule-type\":\"selection\",\"rule-id\":\"1\",\"rule-name\":\"1\",\"object-locator\":{\"schema-name\":\"%\",\"table-name\":\"%\"},\"rule-action\":\"include\"}]}"
    tags = {
      Name = "test"
    }
  }
}

variable "dms_event_subscription" {
  description = "Configuration for the DMS event subscription"
  type = object({
    enabled          = bool
    event_categories = list(string)
    name             = string
    #source_ids       = list(string)
    source_type      = string
    tags = map(string)
  })
  default = {
    enabled          = true
    event_categories = ["creation", "failure"]
    name             = "my-favorite-event-subscription"
    #source_ids       = [aws_dms_replication_task.test.replication_task_id]
    source_type      = "replication-task"
    tags = {
      Name = "example"
    }
  }
}
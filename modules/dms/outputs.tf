output "replication_instance_id" {
  description = "The ID of the replication instance"
  value       = aws_dms_replication_instance.test.replication_instance_id
}

output "source_endpoint_id" {
  description = "The ID of the source endpoint"
  value       = aws_dms_endpoint.source.endpoint_id
}

output "source_endpoint_arn" {
  description = "The ARN of the source endpoint"
  value       = aws_dms_endpoint.source.endpoint_arn
}

output "target_endpoint_id" {
  description = "The ID of the target endpoint"
  value       = aws_dms_endpoint.target.endpoint_id
}

output "replication_task_id" {
  description = "The ID of the replication task"
  value       = aws_dms_replication_task.test.replication_task_id
}

output "certificate_arn" {
  description = "The ARN of the certificate"
  value       = aws_dms_certificate.test.certificate_arn
}

output "replication_instance_arn" {
  description = "The ARN of the replication instance"
  value       = aws_dms_replication_instance.test.replication_instance_arn
}
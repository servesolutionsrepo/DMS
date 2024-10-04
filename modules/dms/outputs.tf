output "replication_instance_id" {
  description = "The ID of the replication instance"
  value       = aws_dms_replication_instance.example.replication_instance_id
}

output "source_endpoint_id" {
  description = "The ID of the source endpoint"
  value       = aws_dms_endpoint.source.endpoint_id
}

output "target_endpoint_id" {
  description = "The ID of the target endpoint"
  value       = aws_dms_endpoint.target.endpoint_id
}

output "replication_task_id" {
  description = "The ID of the replication task"
  value       = aws_dms_replication_task.example.replication_task_id
}
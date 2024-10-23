output "vpc_id" {
  value = aws_vpc.main.id
}

output "instance_profile" {
  value = aws_iam_instance_profile.ip.id
}
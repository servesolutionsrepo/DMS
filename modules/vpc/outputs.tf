output "vpc_id" {
  value = aws_vpc.main.id
}

output "instance_profile" {
  value = aws_iam_instance_profile.ip.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_ids" {
  value = [aws_subnet.private1.id, aws_subnet.private2.id]
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "dms_sg_id" {
  value = aws_security_group.dms_sg.id
}
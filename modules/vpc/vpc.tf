# Create VPC
resource "aws_vpc" "main" {
  cidr_block                     = var.vpc_cidr
  enable_dns_support             = var.enable_dns_support
  enable_dns_hostnames           = var.enable_dns_hostnames
  tags = merge(
    var.tags,
    {
      Name = format("%s-VPC", var.name)
    },
  )
}



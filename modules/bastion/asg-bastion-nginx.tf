#### creating sns topic for all the auto scaling groups
# Get list of availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# creating sns topic for all the auto scaling groups
resource "aws_sns_topic" "ACS-sns" {
  name = "Default_CloudWatch_Alarms_Topic"
}

# creating notification for all the auto scaling groups
resource "aws_autoscaling_notification" "dms_notifications" {
  group_names = [
    aws_autoscaling_group.bastion-asg.name,
    aws_autoscaling_group.nginx-asg.name,
    aws_autoscaling_group.wordpress-asg.name,
    aws_autoscaling_group.tooling-asg.name,
  ]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.ACS-sns.arn
}
resource "random_shuffle" "az_list" {
  input = data.aws_availability_zones.available.names
}



# ---- Autoscaling for bastion  hosts

resource "aws_autoscaling_group" "bastion-asg" {
  name                      = "bastion-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.desired_capacity["bastion-asg"]

  vpc_zone_identifier = var.public_subnets

  launch_template {
    id      = aws_launch_template.bastion-launch-template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "ACS-bastion"
    propagate_at_launch = true
  }

}

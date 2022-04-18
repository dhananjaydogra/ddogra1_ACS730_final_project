### Module to Create a AWS Launch Configuration

# Step 1 - Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Local variables
locals {
  default_tags = merge(
    var.default_tags,
    { "Env" = var.env }
  )
  name_prefix = "${var.prefix}-${var.env}"
}

  
  
  ##### Step 10:- Create AWS Auto Scaling Group

resource "aws_autoscaling_group" "Group9_Project_ASG" {
  name_prefix      = "${local.name_prefix}-ASG-"
  min_size         =  var.min_size
  desired_capacity =  var.desired_capacity
  max_size         =  var.max_size
  health_check_type  = "ELB"
  target_group_arns  =   [var.target_group_arn ]
  launch_configuration = var.LC_namne
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  vpc_zone_identifier = var.private_subnet_ids
  
  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
tag {
      key  = "Name" 
      value ="${local.name_prefix}-Amazon-VM"
      propagate_at_launch = true
    }
}


###AWS Auto Scaling Policy

resource "aws_autoscaling_policy" "Group9_Project_ASG_ScaleUp_Policy" {
  name                   = "${local.name_prefix}-ASG_ScaleUp_Policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.Group9_Project_ASG.name
}


resource "aws_cloudwatch_metric_alarm" "Group9_Project_ASG_ScaleUpAlarm" {
  alarm_name          = "${local.name_prefix}-ASG_ScaleUpAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = var.scale_up_threshold
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.Group9_Project_ASG.name}"
  }
  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = ["${aws_autoscaling_policy.Group9_Project_ASG_ScaleUp_Policy.arn}"]
}


resource "aws_autoscaling_policy" "Group9_Project_ASG_ScaleDown_Policy" {
  name                   = "${local.name_prefix}-ASG_ScaleDown_Policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.Group9_Project_ASG.name
}


resource "aws_cloudwatch_metric_alarm" "Group9_Project_ASG_ScaleDownAlarm" {
  alarm_name          = "${local.name_prefix}-ASG_ScaleDownAlarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "480"
  statistic           = "Average"
  threshold           = var.scale_down_threshold
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.Group9_Project_ASG.name}"
  }
  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = ["${aws_autoscaling_policy.Group9_Project_ASG_ScaleDown_Policy.arn}"]
}
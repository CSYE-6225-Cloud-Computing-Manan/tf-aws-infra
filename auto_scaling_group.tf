resource "aws_autoscaling_group" "asg" {
  name                = var.asg_name
  max_size            = var.asg_max_size
  min_size            = var.asg_min_size
  desired_capacity    = var.asg_desired_capacity
  force_delete        = true
  default_cooldown    = var.asg_default_cooldown
  vpc_zone_identifier = [for subnet in aws_subnet.public : subnet.id]

  tag {
    key                 = "Name"
    value               = "csye6225_asg_instance"
    propagate_at_launch = true
  }

  launch_template {
    id      = aws_launch_template.ec2_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.alb_tg.arn]
}

resource "aws_autoscaling_policy" "scale-out" {
  name                   = var.asg_scale_out_name
  scaling_adjustment     = var.scaling_adjustment_scale_out
  adjustment_type        = var.adjustment_type
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_cloudwatch_metric_alarm" "scale-out" {
  alarm_name          = var.asg_scale_out_name
  comparison_operator = var.comparison_operator_scale_out
  evaluation_periods  = var.evaluation_periods_scale_out
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold_scale_out

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scale-out.arn]
}

resource "aws_autoscaling_policy" "scale-in" {
  name                   = var.asg_scale_in_name
  scaling_adjustment     = var.scaling_adjustment_scale_in
  adjustment_type        = var.adjustment_type
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_cloudwatch_metric_alarm" "scale-in" {
  alarm_name          = var.asg_scale_in_name
  comparison_operator = var.comparison_operator_scale_in
  evaluation_periods  = var.evaluation_periods_scale_in
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold_scale_in

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scale-in.arn]
}

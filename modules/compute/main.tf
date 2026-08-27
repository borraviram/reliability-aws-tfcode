# Compute Module - Auto Scaling Group for the application tier.
# Best practices:
# - Use launch templates with latest AMI lookups.
# - Deploy across multiple AZs for high availability.
# - User data for bootstrapping with error handling.
# - Use ALB health checks and scaling policies for resilience and cost control.

# -----------------------------------------------------------------------------
# AMI Lookup
# -----------------------------------------------------------------------------
data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# -----------------------------------------------------------------------------
# Launch Template
# -----------------------------------------------------------------------------
resource "aws_launch_template" "this" {
  name_prefix   = "${var.name_prefix}-lt-"
  image_id      = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = base64encode(var.user_data)

  vpc_security_group_ids = var.security_group_ids

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  monitoring {
    enabled = true
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 8
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.tags, {
      Name = "${var.name_prefix}-asg-instance"
    })
  }
}

# -----------------------------------------------------------------------------
# Auto Scaling Group
# -----------------------------------------------------------------------------
resource "aws_autoscaling_group" "this" {
  name                      = "${var.name_prefix}-asg"
  max_size                  = 4
  min_size                  = 2
  desired_capacity          = 2
  health_check_type         = "ELB"
  health_check_grace_period = 180
  default_cooldown          = 60
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = [var.target_group_arn]
  wait_for_capacity_timeout = "10m"
  termination_policies      = ["OldestLaunchTemplate", "Default"]

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.this.id
        version            = "$Latest"
      }
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-asg-instance"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

# -----------------------------------------------------------------------------
# Target Tracking Scaling Policy
# -----------------------------------------------------------------------------
resource "aws_autoscaling_policy" "target_tracking" {
  name                      = "${var.name_prefix}-cpu-target-tracking"
  autoscaling_group_name    = aws_autoscaling_group.this.name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 180

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}

# -----------------------------------------------------------------------------
# Step Scaling Policy for scale-out / scale-in
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.name_prefix}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 60
  alarm_description   = "Scale out when average CPU exceeds 60%"
  alarm_actions       = [aws_autoscaling_policy.step_scale_out.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.name_prefix}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 40
  alarm_description   = "Scale in when average CPU drops below 40%"
  alarm_actions       = [aws_autoscaling_policy.step_scale_in.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }
}

# Scale Out Policy
resource "aws_autoscaling_policy" "step_scale_out" {
  name                      = "${var.name_prefix}-step-scale-out"
  autoscaling_group_name    = aws_autoscaling_group.this.name
  policy_type               = "StepScaling"
  adjustment_type           = "ChangeInCapacity"
  estimated_instance_warmup = 180

  step_adjustment {
    scaling_adjustment          = 1
    metric_interval_lower_bound = 0
    metric_interval_upper_bound = 10
  }

  step_adjustment {
    scaling_adjustment          = 2
    metric_interval_lower_bound = 10
  }
}

# Scale In Policy
resource "aws_autoscaling_policy" "step_scale_in" {
  name                      = "${var.name_prefix}-step-scale-in"
  autoscaling_group_name    = aws_autoscaling_group.this.name
  policy_type               = "StepScaling"
  adjustment_type           = "ChangeInCapacity"
  estimated_instance_warmup = 180

  step_adjustment {
    scaling_adjustment          = -2
    metric_interval_upper_bound = -10
  }

  step_adjustment {
    scaling_adjustment          = -1
    metric_interval_lower_bound = -10
    metric_interval_upper_bound = 0
  }

}

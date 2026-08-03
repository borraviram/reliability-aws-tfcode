# Compute Module - EC2 instances for the application tier.
# Best practices:
# - Use launch templates with latest AMI lookups.
# - Deploy across multiple AZs for high availability.
# - User data for bootstrapping with error handling.

# -----------------------------------------------------------------------------
# AMI Lookup
# -----------------------------------------------------------------------------
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# -----------------------------------------------------------------------------
# EC2 Instances
# -----------------------------------------------------------------------------
resource "aws_instance" "this" {
  count = var.instance_count

  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_ids[count.index]
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.key_name
  user_data                   = var.user_data
  user_data_replace_on_change = true
  associate_public_ip_address = var.associate_public_ip_address

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  monitoring = true

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-ec2-${count.index + 1}"
    }
  )
}

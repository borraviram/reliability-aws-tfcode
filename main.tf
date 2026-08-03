# Root composition for mcp-ai-architecture.

module "vpc" {
  source = "./modules/vpc"

  name_prefix        = local.naming_prefix
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  tags               = local.common_tags
}

module "security" {
  source = "./modules/security"

  name_prefix = local.naming_prefix
  vpc_id      = module.vpc.vpc_id
  tags        = local.common_tags
}

module "compute" {
  source = "./modules/compute"

  name_prefix                 = local.naming_prefix
  subnet_ids                  = module.vpc.private_subnet_ids
  security_group_ids          = [module.security.ec2_security_group_id]
  key_name                    = "kimi-k3"
  instance_count              = 2
  instance_type               = "t3.micro"
  associate_public_ip_address = false

  user_data = <<-EOF
              #!/bin/bash

              # Update system
              yum update -y

              # Install nginx
              if command -v dnf >/dev/null 2>&1; then
                  dnf install nginx -y
              else
                  amazon-linux-extras install nginx1 -y
              fi

              # Get EC2 metadata
              TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
              -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" -s)

              INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s \
              http://169.254.169.254/latest/meta-data/instance-id)

              PRIVATE_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s \
              http://169.254.169.254/latest/meta-data/local-ipv4)

              AZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s \
              http://169.254.169.254/latest/meta-data/placement/availability-zone)

              # Create HTML page
              cat > /usr/share/nginx/html/index.html <<WEBEOF
              <!DOCTYPE html>
              <html>
              <head>
                  <title>AWS ALB Test Page</title>
                  <style>
                      body {
                          font-family: Arial, sans-serif;
                          text-align: center;
                          margin-top: 80px;
                          background-color: #f4f6f9;
                      }
                      .card {
                          width: 500px;
                          margin: auto;
                          padding: 20px;
                          background: white;
                          border-radius: 10px;
                          box-shadow: 0px 2px 10px rgba(0,0,0,0.1);
                      }
                      h1 { color: #0073bb; }
                      p  { font-size: 20px; }
                  </style>
              </head>
              <body>
                  <div class="card">
                      <h1>Application Running Successfully</h1>
                      <p><b>Instance ID:</b> $INSTANCE_ID</p>
                      <p><b>Private IP:</b> $PRIVATE_IP</p>
                      <p><b>Availability Zone:</b> $AZ</p>
                  </div>
              </body>
              </html>
              WEBEOF

              # Start nginx
              systemctl enable nginx
              systemctl restart nginx
              EOF

  tags = local.common_tags
}

module "load_balancer" {
  source = "./modules/load_balancer"

  name_prefix        = local.naming_prefix
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  security_group_ids = [module.security.alb_security_group_id]
  instance_ids       = module.compute.instance_ids
  tags               = local.common_tags
}

#
# module "database" {
#   source = "./modules/database"
#   ...
# }
#
# module "monitoring" {
#   source = "./modules/monitoring"
#   ...
# }

# Return the arn of the container repository for our image.
data "aws_ecr_repository" "webapp" {
  name = var.container
}

# Default role for AppRunner to access a private ECR registry.
data "aws_iam_role" "AppRunnerECRAccessRole" {
  name = "AppRunnerECRAccessRole"
}

# Create an AppRunner service that will run our container and manage load balancing, ssl certificates and scalling.
resource "aws_apprunner_service" "webapp" {
  service_name = var.service_name
  source_configuration {
    authentication_configuration {
      access_role_arn = data.aws_iam_role.AppRunnerECRAccessRole.arn
    }
    image_repository {
      image_configuration {
        port = "8080"
      }
      image_identifier      = "${data.aws_ecr_repository.webapp.repository_url}:latest"
      image_repository_type = "ECR"
    }
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.webapp_autoscalling.arn

  tags = {
    Name = var.service_name
  }
}

# Autoscaling configuration, 2 instances min ( to demonstrate load balancing )
resource "aws_apprunner_auto_scaling_configuration_version" "webapp_autoscalling" {
  auto_scaling_configuration_name = var.service_name
  max_concurrency                 = 50
  min_size                        = 2
  max_size                        = 3

  tags = {
    Name = "${var.service_name}-autoscaling-config"
  }
}

# Custom domain used for accessing the webapp
resource "aws_apprunner_custom_domain_association" "suslian_engineer" {
  domain_name          = "${var.custom_subdomain}.${var.custom_domain}"
  service_arn          = aws_apprunner_service.webapp.arn
  enable_www_subdomain = false
}

# Cloudflare zone used with the custom domain
data "cloudflare_zones" "suslian_engineer" {
  filter {
    name = var.custom_domain
  }
}

# Automatic http to https redirection
resource "cloudflare_page_rule" "https" {
  zone_id = data.cloudflare_zones.suslian_engineer.zones[0].id
  target  = "*.${var.custom_domain}/*"
  actions {
    automatic_https_rewrites = "on"
  }
}

# Create the custom domain record on Cloudflare
resource "cloudflare_record" "suslian_engineer" {
  zone_id = data.cloudflare_zones.suslian_engineer.zones[0].id
  name    = var.custom_subdomain
  value   = aws_apprunner_service.webapp.service_url
  type    = "CNAME"
}

# Create the DNS records required for the SSL certificate validation
resource "cloudflare_record" "aws_acm_validation" {
  count   = length(aws_apprunner_custom_domain_association.suslian_engineer.certificate_validation_records)
  zone_id = data.cloudflare_zones.suslian_engineer.zones[0].id
  name    = tolist(aws_apprunner_custom_domain_association.suslian_engineer.certificate_validation_records)[count.index].name
  value   = tolist(aws_apprunner_custom_domain_association.suslian_engineer.certificate_validation_records)[count.index].value
  type    = "CNAME"
}

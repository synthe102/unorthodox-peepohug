terraform {
  required_version = "1.0.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.62.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.1.0"
    }
  }
  backend "s3" {
    bucket = "terraform-states-homelab"
    key    = "webapp-demo/terraform.tfstate"
    region = "eu-west-1"
  }
}

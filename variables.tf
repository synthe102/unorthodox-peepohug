variable "custom_domain" {
  type    = string
  default = "suslian.engineer"
  description = "The custom domain to associate with the AppRunner service"
}

variable "custom_subdomain" {
  type    = string
  default = "webapp"
  description = "The custom subdomain to associate with the AppRunner service"
}

variable "container" {
  type    = string
  default = "webapp"
  description = "Name of the image repository on ECR"
}

variable "service_name" {
  type    = string
  default = "webapp"
  description = "Name to give to the AppRunner service"
}

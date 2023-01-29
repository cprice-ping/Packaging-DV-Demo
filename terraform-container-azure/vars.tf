variable "region" {
  type        = string
  description = "Region your P1 Org is in"
}

variable "organization_id" {
  type        = string
  description = "Your P1 Organization ID"
}

variable "license_name" {
  type        = string
  description = "Name of the P1 license you want to assign to the Environment"
}

variable "admin_env_id" {
  type        = string
  description = "P1 Environment containing the Worker App"
}

variable "admin_user_id" {
  type        = string
  description = "P1 Administrator to assign Roles to"
  sensitive   = true
}

variable "admin_user_name" {
  type        = string
  description = "P1 Administrator username to connect to DaVinci with"
  sensitive   = true
}

variable "admin_user_password" {
  type        = string
  description = "P1 Administrator password to connect to DaVinci with"
  sensitive   = true
}

variable "worker_id" {
  type        = string
  description = "Worker App ID App - App must have sufficient Roles"
  sensitive   = true
}

variable "worker_secret" {
  type        = string
  description = "Worker App Secret - App must have sufficient Roles"
  sensitive   = true
}

variable "env_name" {
  type        = string
  description = "Name used for the PingOne Environment"
}

variable "app_policy_name" {
  type        = string
  description = "Name of the Policy you'd like to run - must be defined on the DaVinci Application"
}

# variable "docker_image" {
#   type = string
#   description = "(optional) describe your variable"
# }

# variable "docker_image_tag" {
#   type = string
#   description = "(optional) describe your variable"
# }

locals {
  # Extract the DV Policies assigned to the DV Application
  app_policy = { for i in davinci_application.initial_policy.policies : "${i.name}" => i.policy_id }

  # Translate the Region to a Domain suffix
  north_america  = var.region == "NorthAmerica" ? "com" : ""
  europe         = var.region == "Europe" ? "eu" : ""
  canada         = var.region == "Canada" ? "ca" : ""
  asia_pacific   = var.region == "AsiaPacific" ? "asia" : ""
  pingone_domain = coalesce(local.north_america, local.europe, local.canada, local.asia_pacific)
}

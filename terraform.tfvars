variable "resource_group_name" {
  description = "Azure resource group that will hold all resources created by the tf plan."
  default = "labNoSecInfra"
}

variable "tag_environment" {
  description = "Tag to identify the environment this plan runs in, e.g. SecLab, Dev."
  default = "SecLab"
}

variable "tag_team" {
  description = "Tag to identify the team running this plan, e.g. DevSecOps, Developers"
  default = "DevSecOps"
}

# We insecurely define default values for admin user and pass in the variables config
# instead of asking for the info at runtime
variable "mysql_admin_user" {
  description = "Username for admin with full access to database"
  default = "SecLabAdmin"
}

variable "mysql_admin_password" {
  description = "Password for admin with full access to database"
  default = "!SecLabAdminSuperInsecure123!!"
}
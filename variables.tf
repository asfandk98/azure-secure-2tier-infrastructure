variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "India South Central"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-secure-2tier-portfolio"
}

variable "admin_ip" {
  description = "Your public IP, allowed to SSH into the web tier"
  type        = string
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "azureuser"
}

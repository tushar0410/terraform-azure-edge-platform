variable "resource_group_name" {
  description = "Name of the dedicated resource group for Terraform state infrastructure."
  type        = string

  validation {
    condition     = can(regex("^rg-[a-z0-9-]{3,80}$", var.resource_group_name))
    error_message = "resource_group_name must start with rg- and use lowercase letters, numbers, and hyphens."
  }
}

variable "location" {
  description = "Azure region for the Terraform state resource group and storage account."
  type        = string
  default     = "eastus2"
}

variable "storage_account_name" {
  description = "Globally unique name of the StorageV2 account used only for Terraform state."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "storage_account_name must contain 3 to 24 lowercase letters or numbers."
  }
}

variable "state_container_name" {
  description = "Name of the private blob container that stores Terraform state files."
  type        = string
  default     = "tfstate"

  validation {
    condition     = can(regex("^[a-z0-9](?:[a-z0-9-]{1,61}[a-z0-9])?$", var.state_container_name))
    error_message = "state_container_name must be 3 to 63 characters of lowercase letters, numbers, and hyphens."
  }
}

variable "state_access_principal_ids" {
  description = "Entra ID object IDs that require Storage Blob Data Contributor on the state account. Include the bootstrap deployer and later CI identities."
  type        = set(string)

  validation {
    condition     = length(var.state_access_principal_ids) > 0 && alltrue([for principal_id in var.state_access_principal_ids : can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", principal_id))])
    error_message = "state_access_principal_ids must contain at least one Entra ID object ID in GUID format."
  }
}

variable "allowed_ip_ranges" {
  description = "Approved public IPv4 CIDR ranges for Terraform data-plane access to the state account. Use /32 for a single trusted address."
  type        = set(string)

  validation {
    condition     = alltrue([for cidr in var.allowed_ip_ranges : can(cidrnetmask(cidr))])
    error_message = "allowed_ip_ranges entries must be valid IPv4 CIDR ranges."
  }
}

variable "account_replication_type" {
  description = "Replication type for the state storage account. ZRS is preferred when supported in the selected region."
  type        = string
  default     = "ZRS"

  validation {
    condition     = contains(["LRS", "ZRS", "GRS", "GZRS", "RAGRS", "RAGZRS"], var.account_replication_type)
    error_message = "account_replication_type must be a supported Standard StorageV2 replication type."
  }
}

variable "blob_soft_delete_retention_days" {
  description = "Number of days deleted state blobs remain recoverable."
  type        = number
  default     = 30

  validation {
    condition     = var.blob_soft_delete_retention_days >= 1 && var.blob_soft_delete_retention_days <= 365
    error_message = "blob_soft_delete_retention_days must be between 1 and 365."
  }
}

variable "container_soft_delete_retention_days" {
  description = "Number of days deleted state containers remain recoverable."
  type        = number
  default     = 30

  validation {
    condition     = var.container_soft_delete_retention_days >= 1 && var.container_soft_delete_retention_days <= 365
    error_message = "container_soft_delete_retention_days must be between 1 and 365."
  }
}

variable "previous_version_retention_days" {
  description = "Number of days to retain noncurrent blob versions before lifecycle deletion. Active state is never selected by this rule."
  type        = number
  default     = 365

  validation {
    condition     = var.previous_version_retention_days >= 30 && var.previous_version_retention_days <= 3650
    error_message = "previous_version_retention_days must be between 30 and 3650."
  }
}

variable "tags" {
  description = "Additional tags applied to all bootstrap resources."
  type        = map(string)
  default     = {}
}

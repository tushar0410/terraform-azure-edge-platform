# Remote state is intentionally not configured in the initial repository commit.
#
# The state backend is bootstrapped separately because a Terraform backend must
# exist before it can store state. Do not place state in the workload storage
# account. After the bootstrap implementation and RBAC model are approved,
# each environment root will use a configuration equivalent to the following:
#
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "<bootstrap-resource-group>"
#     storage_account_name = "<bootstrap-state-storage-account>"
#     container_name       = "tfstate"
#     key                  = "<environment>.tfstate"
#     use_azuread_auth     = true
#   }
# }
#
# Backend values must be supplied through approved environment-specific backend
# configuration, not committed as credentials or tenant-specific values.

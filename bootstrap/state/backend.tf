# The bootstrap root starts with local state because it creates the remote
# backend. After the first successful apply, uncomment the block below and run
# `terraform init -migrate-state -backend-config=backend.hcl` with a local,
# uncommitted backend.hcl file based on backend.hcl.example.
#
# terraform {
#   backend "azurerm" {}
# }

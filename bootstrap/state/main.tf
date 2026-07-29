locals {
  default_tags = {
    component  = "terraform-state"
    managed_by = "terraform"
    workload   = "edge-platform"
  }

  tags = merge(local.default_tags, var.tags)
}

resource "azurerm_resource_group" "state" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.tags
}

resource "azurerm_storage_account" "state" {
  name                              = var.storage_account_name
  resource_group_name               = azurerm_resource_group.state.name
  location                          = azurerm_resource_group.state.location
  account_kind                      = "StorageV2"
  account_tier                      = "Standard"
  account_replication_type          = var.account_replication_type
  access_tier                       = "Hot"
  min_tls_version                   = "TLS1_2"
  https_traffic_only_enabled        = true
  allow_nested_items_to_be_public   = false
  shared_access_key_enabled         = false
  default_to_oauth_authentication  = true
  local_user_enabled                = false
  cross_tenant_replication_enabled = false

  blob_properties {
    versioning_enabled = true
    change_feed_enabled = true

    delete_retention_policy {
      days = var.blob_soft_delete_retention_days
    }

    container_delete_retention_policy {
      days = var.container_soft_delete_retention_days
    }
  }

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    ip_rules       = var.allowed_ip_ranges
  }

  tags = local.tags

  lifecycle {
    prevent_destroy = true

    precondition {
      condition     = length(var.allowed_ip_ranges) > 0
      error_message = "At least one approved deployer IPv4 CIDR must be supplied in allowed_ip_ranges."
    }
  }
}

resource "azurerm_role_assignment" "state_data_contributor" {
  for_each = var.state_access_principal_ids

  scope                = azurerm_storage_account.state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.value
}

resource "azurerm_storage_container" "state" {
  name                  = var.state_container_name
  storage_account_id    = azurerm_storage_account.state.id
  container_access_type = "private"

  depends_on = [azurerm_role_assignment.state_data_contributor]
}

resource "azurerm_storage_management_policy" "state" {
  storage_account_id = azurerm_storage_account.state.id

  rule {
    name    = "retain-state-versions"
    enabled = true

    filters {
      blob_types   = ["blockBlob"]
      prefix_match = ["${var.state_container_name}/"]
    }

    actions {
      version {
        delete_after_days_since_creation = var.previous_version_retention_days
      }
    }
  }
}

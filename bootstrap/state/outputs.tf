output "resource_group_id" {
  description = "Resource ID of the dedicated Terraform state resource group."
  value       = azurerm_resource_group.state.id
}

output "storage_account_id" {
  description = "Resource ID of the Terraform state storage account."
  value       = azurerm_storage_account.state.id
}

output "storage_account_name" {
  description = "Name of the Terraform state storage account."
  value       = azurerm_storage_account.state.name
}

output "state_container_name" {
  description = "Name of the private Terraform state blob container."
  value       = azurerm_storage_container.state.name
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint for the state storage account."
  value       = azurerm_storage_account.state.primary_blob_endpoint
}

output "backend_configuration" {
  description = "Non-secret AzureRM backend values. Set key independently for each environment."
  value = {
    resource_group_name  = azurerm_resource_group.state.name
    storage_account_name = azurerm_storage_account.state.name
    container_name       = azurerm_storage_container.state.name
    key                  = "<environment>.tfstate"
    use_azuread_auth     = true
  }
}

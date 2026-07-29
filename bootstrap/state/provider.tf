provider "azurerm" {
  features {}

  # The state account disables shared-key access. This flag directs AzureRM
  # storage data-plane operations to use the authenticated Entra ID principal.
  storage_use_azuread = true
}

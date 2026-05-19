resource "azurerm_storage_account" "main" {
  name                     = "st${replace(local.prefix, "-", "")}${local.suffix}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = local.tags
}

# Container for batch results
resource "azurerm_storage_container" "results" {
  name                  = "results"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Container for Azure Functions internal use
resource "azurerm_storage_container" "functions" {
  name                  = "azure-webjobs-hosts"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "storage_results_container" {
  value = azurerm_storage_container.results.name
}

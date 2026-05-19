resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-${local.prefix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}

resource "azurerm_application_insights" "main" {
  name                = "appi-${local.prefix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"
  tags                = local.tags
}

resource "azurerm_service_plan" "functions" {
  name                = "asp-${local.prefix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Windows"
  sku_name            = var.functions_sku_size == "Y1" ? "Y1" : var.functions_sku_size
  tags                = local.tags
}

resource "azurerm_windows_function_app" "main" {
  name                       = "func-${local.prefix}-${local.suffix}"
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  service_plan_id            = azurerm_service_plan.functions.id
  storage_account_name       = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key

  # Key Vault 参照に必要なシステム割り当てマネージド ID
  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      dotnet_version              = "v8.0"
      use_dotnet_isolated_runtime = true
    }
    application_insights_key               = azurerm_application_insights.main.instrumentation_key
    application_insights_connection_string = azurerm_application_insights.main.connection_string
  }

  app_settings = {
    FUNCTIONS_EXTENSION_VERSION = "~4"
    WEBSITE_RUN_FROM_PACKAGE    = "1"

    # 機密情報は Key Vault 参照で読み込む（平文をアプリ設定に持たない）
    SqlConnectionString     = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=SqlConnectionString)"
    StorageConnectionString = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=StorageConnectionString)"
    AcsConnectionString     = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=AcsConnectionString)"

    ResultsContainerName = azurerm_storage_container.results.name
  }

  tags = local.tags
}

output "function_app_name" {
  value = azurerm_windows_function_app.main.name
}

output "function_app_default_hostname" {
  value = azurerm_windows_function_app.main.default_hostname
}

output "application_insights_instrumentation_key" {
  value     = azurerm_application_insights.main.instrumentation_key
  sensitive = true
}

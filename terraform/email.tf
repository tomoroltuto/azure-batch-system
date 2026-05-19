# Azure Communication Services
# Email send functionality will be implemented in a later phase.
# This file provisions the ACS resource and Email Communication Service domain.

resource "azurerm_communication_service" "main" {
  name                = "acs-${local.prefix}-${local.suffix}"
  resource_group_name = azurerm_resource_group.main.name
  data_location       = "Japan"
  tags                = local.tags
}

resource "azurerm_email_communication_service" "main" {
  name                = "acs-email-${local.prefix}-${local.suffix}"
  resource_group_name = azurerm_resource_group.main.name
  data_location       = "Japan"
  tags                = local.tags
}

# AzureManagedDomain provides a ready-to-use sender domain (e.g. xxxxxxxx.azurecomm.net).
# Replace with a custom domain resource when your verified domain is available.
resource "azurerm_email_communication_service_domain" "managed" {
  name              = "AzureManagedDomain"
  email_service_id  = azurerm_email_communication_service.main.id
  domain_management = "AzureManaged"
}

output "acs_resource_name" {
  value = azurerm_communication_service.main.name
}

output "acs_email_sender_domain" {
  value = azurerm_email_communication_service_domain.managed.mail_from_sender_domain
}

output "acs_primary_connection_string" {
  value     = azurerm_communication_service.main.primary_connection_string
  sensitive = true
}

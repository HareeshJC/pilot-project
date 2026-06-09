resource "azurerm_servicebus_queue_authorization_rule" "main" {
  name     = var.sharedaccesskey_name
  queue_id = var.servicebus_queue_id

  listen = var.listen
  send   = var.send
  manage = var.manage
}
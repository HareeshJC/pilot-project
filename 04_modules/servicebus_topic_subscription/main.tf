resource "azurerm_servicebus_subscription" "main" {
  name                                      = var.name
  topic_id                                  = var.topic_id
  max_delivery_count                        = try(var.settings.max_delivery_count, null)
  default_message_ttl                       = try(var.settings.default_message_ttl, null)
  auto_delete_on_idle                       = try(var.settings.auto_delete_on_idle, null)
  lock_duration                             = try(var.settings.lock_duration, null)
  dead_lettering_on_message_expiration      = try(var.settings.dead_lettering_on_message_expiration, null)
  dead_lettering_on_filter_evaluation_error = try(var.settings.dead_lettering_on_filter_evaluation_error, null)
  batched_operations_enabled                = try(var.settings.enable_batched_operations, false)
  requires_session                          = try(var.settings.requires_session, null)
  forward_to                                = try(var.settings.forward_to, null)
  forward_dead_lettered_messages_to         = try(var.settings.forward_dead_lettered_messages_to, null)
  status                                    = try(var.settings.status, "Active")
  client_scoped_subscription_enabled        = try(var.settings.client_scoped_subscription_enabled, null)


  lifecycle {
    ignore_changes = [
      batched_operations_enabled,
      dead_lettering_on_message_expiration,
      max_delivery_count
    ]
  }
}
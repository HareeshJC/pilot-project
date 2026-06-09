resource "azurerm_servicebus_queue" "main" {
  name         = var.queue_name
  namespace_id = var.namespace_id

  status = try(var.settings.status, "Active")

  auto_delete_on_idle                     = try(var.settings.auto_delete_on_idle, null)
  default_message_ttl                     = try(var.settings.default_message_ttl, null)
  duplicate_detection_history_time_window = try(var.settings.duplicate_detection_history_time_window, "PT10M")
  batched_operations_enabled              = try(var.settings.enable_batched_operations, true)
  express_enabled                         = try(var.settings.enable_express, false)
  partitioning_enabled                    = try(var.settings.enable_partitioning, false)
  lock_duration                           = try(var.settings.lock_duration, "PT5M")
  max_message_size_in_kilobytes           = try(var.settings.max_message_size_in_kilobytes, null)
  max_size_in_megabytes                   = try(var.settings.max_size_in_megabytes, null)
  requires_duplicate_detection            = try(var.settings.requires_duplicate_detection, false)
  requires_session                        = try(var.settings.requires_session, false)
  dead_lettering_on_message_expiration    = try(var.settings.dead_lettering_on_message_expiration, true)
  max_delivery_count                      = try(var.settings.max_delivery_count, 10)
}


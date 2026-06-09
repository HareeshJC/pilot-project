alert_action_groups = [
  {
    name                = "aag-sbq-dlq-pilot-sev3-__#environment_abbr#__-__#environment_instance#__"
    resource_group_name = "rg-__#environment_abbr#__-__#service_id#__-pilot-integration-__#location_abbreviation#__-__#environment_instance#__"
    short_name          = "aag-pil-sv3"
  }
]

// ============================
// pilot Alerts
// ============================
alert_common = {
  frequency     = "PT15M"
  window_size   = "PT15M"
  aggregation   = "Average"
  threshold     = 0
  operator      = "GreaterThan"
  enabled       = true
  auto_mitigate = false
  severity      = 3
}

alerts = [
  {
    metric_alert_name   = "sb-dlq-pilot-alert-__#environment_abbr#__-__#service_id#__-__#location_abbreviation#__-__#environment_instance#__"
    resource_group_name = "rg-__#environment_abbr#__-__#service_id#__-pilot-integration-__#location_abbreviation#__-__#environment_instance#__"
    resource_names      = ["sb-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"]
    action_group_name   = "aag-sbq-dlq-pilot-sev3-__#environment_abbr#__-__#environment_instance#__"
    severity            = 3
    description         = "Sev 3 alert for service bus queue dlq count greater than 0"
    metric_namespace    = "Microsoft.ServiceBus/namespaces"
    metric_name         = "DeadletteredMessages"
    resource_type       = "servicebus_namespaces"
    frequency           = "PT5M"
    window_size         = "PT5M"
    threshold           = 0
    dimension_name      = "EntityName"
    dimension_operator  = "Include"
    enabled             = true
    dimension_values    = ["sbq-__#environment_abbr#__-pilot-__#service_id#__-__#location_abbreviation#__-__#environment_instance#__"]
    custom_properties = {
      "project"      = "pilot-project"
      "p2_DLQ_Count" = "10"
      "p3_DLQ_Count" = "5"
      "notification" = "To prevent further dead-lettering, please reprocess the failed messages corresponding to the batch IDs in the DLQ of "
    }
    tags = {
      "Frequency"   = "5m"
      "Priority"    = "P3"
      "Environment" = "__#environment_abbr#__-__#environment_instance#__"
    }
  }
]
variable "name" {
  type        = string
  description = "(Required) The name which should be used for this Topic Subscription. Changing this forces a new Topic Subscription to be created."
}

variable "topic_id" {
  type        = string
  description = "(Required) The name of the Resource Group where the Topic Subscription should exist. Changing this forces a new Topic Subscription to be created."

}

variable "settings" {
  type = object({
    max_delivery_count                        = optional(number, 100)
    auto_delete_on_idle                       = optional(string, null)
    default_message_ttl                       = optional(string, null)
    lock_duration                             = optional(string, null)
    dead_lettering_on_message_expiration      = optional(bool, false)
    dead_lettering_on_filter_evaluation_error = optional(bool, false)
    batched_operations_enabled                = optional(bool, false)
    requires_session                          = optional(bool, false)
    forward_to                                = optional(string, null)
    forward_dead_lettered_messages_to         = optional(string, null)
    status                                    = optional(string, "Active")
    client_scoped_subscription_enabled        = optional(bool, false)
    subscription_rule_name                    = optional(string, null)
    subscription_filter_type                  = optional(string, "SqlFilter")
    subscription_filter                       = optional(string, null)
  })
  description = <<-EOT
        provision settings value for service bus subscription as defined below:
        ```           
          max_delivery_count = (Required) The maximum number of deliveries.

          auto_delete_on_idle = (Optional) The idle interval after which the topic is automatically deleted as an ISO 8601 duration..

          default_message_ttl = (Optional) The Default message timespan to live as an ISO 8601 duration. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself.

          lock_duration = (Optional) The lock duration for the subscription as an ISO 8601 duration.

          dead_lettering_on_message_expiration = (Optional) Boolean flag which controls whether the Subscription has dead letter support when a message expires.

          dead_lettering_on_filter_evaluation_error = (Optional) Boolean flag which controls whether the Subscription has dead letter support on filter evaluation exceptions. Defaults to true.

          batched_operations_enabled = (Optional) Boolean flag which controls whether the Subscription supports batched operations.

          requires_session = (Optional) Boolean flag which controls whether this Subscription supports the concept of a session. Changing this forces a new resource to be created.

          forward_to = (Optional) The name of a Queue or Topic to automatically forward messages to.

          forward_dead_lettered_messages_to = (Optional) The name of a Queue or Topic to automatically forward Dead Letter messages to.

          status = (Optional) The status of the Subscription. Possible values are Active,ReceiveDisabled, or Disabled. Defaults to Active.

          client_scoped_subscription_enabled = (Optional) whether the subscription is scoped to a client id. Defaults to False.

          subscription_rule_name = (Optional) The subscription Rule name

          subscription_filter_type = (Optional) The subscription Filter type whether its sqlfilter or other.
        ```
    EOT

}

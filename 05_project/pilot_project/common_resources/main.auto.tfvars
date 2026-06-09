resource_groups = [
  {
    name = "rg-__#environment_abbr#__-__#service_id#__-pilot-integration-__#location_abbreviation#__-__#environment_instance#__"
    tags = {
      project = "pilot-project"
    }
  }
]

servicebus_queues = [
  {
    servicebus_name = "sb-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    name            = "sbq-__#environment_abbr#__-pilot-__#service_id#__-__#location_abbreviation#__-__#environment_instance#__"
  }
]

servicebus_queue_sas = [
  # {
  #   name       = "sb-sas-listen-__#environment_abbr#__-__#service_id#__-__#environment_instance#__"
  #   queue_name = "sbq-__#environment_abbr#__-pilot-__#service_id#__-__#location_abbreviation#__-__#environment_instance#__"

  #   listen = true

  #   secret_management = {
  #     keyvault_name = "kv-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
  #   }
  # }
]
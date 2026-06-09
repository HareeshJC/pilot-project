container_apps = [
  {
    name                           = "ca-api-__#location_abbreviation#__-__#component_instance#__"
    resource_group_name            = "rg-__#environment_abbr#__-__#service_id#__-pilot-integration-__#location_abbreviation#__-__#environment_instance#__"
    container_app_environment_name = "ace-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    containerapp_access_role       = "azgrp-__#environment_abbr#__-__#service_id#__-__#environment_instance#___container_app_contributor"
    tags = {
      "Type"              = "ContainerApp"
      "Usage"             = "transaction-ingestor"
      "DependantResource" = "container apps environment"
      "Project"           = "Pilot-Project"
    }
    identity = {
      type            = "SystemAssigned, UserAssigned"
      user_managed_id = "lz-__#environment_abbr#__-__#service_id#__-umid-__#environment_instance#__"
    }
    secrets = [
      {
        identity            = "System"
        key_vault_secret_id = "https://kv-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__.vault.azure.net/secrets/acr__#environment_abbr#____#service_id#__shared__#location_abbreviation#____#environment_instance#__-password"
        name                = "registry-password-secret"
      },
      {
        identity            = "System"
        key_vault_secret_id = "https://kv-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__.vault.azure.net/secrets/sb-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__-connection-string"
        name                = "servicebusconnstring"
      }
    ]
    registry = {
      server               = "acr__#environment_abbr#____#service_id#__shared__#location_abbreviation#____#environment_instance#__.azurecr.io"
      username             = "acr__#environment_abbr#____#service_id#__shared__#location_abbreviation#____#environment_instance#__"
      password_secret_name = "registry-password-secret"
    }
    template = {
      min_replicas = 1
      max_replicas = 2
      containers = [
        {
          name    = "ca-__#environment_abbr#__-pilot-ingestor-__#environment_instance#__"
          server  = "acr__#environment_abbr#____#service_id#__shared__#location_abbreviation#____#environment_instance#__.azurecr.io"
          image   = "api"
          tag     = "latest"
          cpu     = 2.0
          memory  = "4Gi"
          args    = []
          command = []
          env = [
            {
              name  = "KeyVaultUri"
              value = "https://kv-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__.vault.azure.net"
            },
            {
              name              = "ConnectionStrings__ServiceBusConnection"
              value_from_secret = "servicebusconnstring"
            },
            {
              name              = "APPINSIGHTS_INSTRUMENTATIONKEY"
              value_from_secret = "appi-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__-instrumentation-key"
            }
          ]
          volume_mounts = []
          readiness_probe = [
            {
              initial_delay           = 10
              interval_seconds        = 15
              failure_count_threshold = 3
              timeout                 = 10
              host                    = ""
              port                    = 8080
              path                    = "/api/health/ready"
              transport               = "HTTP"
              header                  = []
            }
          ]
          liveness_probe = [
            {
              initial_delay           = 10
              interval_seconds        = 30
              failure_count_threshold = 3
              timeout                 = 10
              host                    = ""
              port                    = 8080
              path                    = "/api/health/live"
              transport               = "HTTP"
              header                  = []
            }
          ]
        }
      ]
      custom_scale_rules = [
        {
          name             = "azure-servicebus-triggered"
          custom_rule_type = "azure-servicebus"
          metadata = {
            connectionFromEnv = "servicebusconnstring"
            queueName         = "sbq-__#environment_abbr#__-pilot-__#service_id#__-__#location_abbreviation#__-__#environment_instance#__"
            messageCount      = "20"
            cloud             = "AzurePublicCloud"
          }
          authentication = {
            secret_name       = "servicebusconnstring"
            trigger_parameter = "connection"
          }
        }
      ]
    }
  }
]

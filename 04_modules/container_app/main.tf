resource "azurerm_container_app" "container_app" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.container_app_environment_id
  revision_mode                = var.revision_mode
  workload_profile_name        = var.workload_profile_name //(this can be use < = 4.7.0 terrfrom azurerm provider version )
  tags                         = var.tags

  dynamic "identity" {
    for_each = lookup(var.settings, "identity", {}) == {} ? [] : [1]

    content {
      type         = var.settings.identity.type
      identity_ids = (try(var.settings.identity.type, {}) == "SystemAssigned") ? [] : [var.user_assigned_identity[var.settings.identity.user_managed_id].id]
    }
  }
  dynamic "secret" {
    for_each = try(var.settings.secrets, []) != [] ? var.settings.secrets : []
    content {
      identity = try(secret.value["identity"], null) //(this can be use < = 4.7.0 terrfrom azurerm provider version )
      # Conditional inclusion of Key Vault references
      key_vault_secret_id = try(secret.value["key_vault_secret_id"], null) //(this can be use < = 4.7.0 terrfrom azurerm provider version )
      name                = secret.value["name"]
      # `value` will only be used if `key_vault_secret_id` and `identity` are not specified
      value = try(secret.value["value"], null)
    }
  }
  # Dynamic registry block
  dynamic "registry" {
    for_each = try(var.settings.registry != null ? [var.settings.registry] : [])
    content {
      server   = registry.value.server              #try(var.data_cr.login_server, null)
      username = try(registry.value.username, null) #try(var.data_cr.admin_username, null)
      password_secret_name = try(
        { for secret in var.settings.secrets : secret.name => secret.name }[registry.value.password_secret_name],
        null
      )
      identity = try(registry.value["identity"], null)
    }
  }
  template {
    min_replicas = var.settings.template.min_replicas
    max_replicas = var.settings.template.max_replicas

    dynamic "container" {
      for_each = { for inst in var.settings.template.containers : inst.name => inst }
      content {
        name   = container.value.name
        image  = "${container.value.server}/${container.value.image}:${container.value.tag}"
        cpu    = container.value.cpu
        memory = container.value.memory

        args    = container.value.args
        command = container.value.command

        # Dynamic environment variables
        dynamic "env" {
          for_each = container.value.env != null ? container.value.env : []
          content {
            name        = env.value.name
            value       = try(env.value.value, null)
            secret_name = try(env.value.secret_name, null)
          }
        }

        # Dynamic volume mounts
        dynamic "volume_mounts" {
          for_each = container.value.volume_mounts != null ? container.value.volume_mounts : []
          content {
            name = volume_mounts.value.name
            path = volume_mounts.value.path
          }
        }
        dynamic "startup_probe" {
          for_each = try(container.value.startup_probe, [])
          content {
            failure_count_threshold = try(startup_probe.value.failure_count_threshold, 3)
            initial_delay           = try(startup_probe.value.initial_delay, 1)
            interval_seconds        = try(startup_probe.value.interval_seconds, 10)
            host                    = try(startup_probe.value.host, null)
            path                    = try(startup_probe.value.path, null)
            port                    = try(startup_probe.value.port, 8080)
            transport               = try(startup_probe.value.transport, "HTTP")
            timeout                 = try(startup_probe.value.timeout, 1)
            dynamic "header" {
              for_each = try(startup_probe.value.header, [])
              content {
                name  = try(header.value.name, null)
                value = try(header.value.value, null)
              }
            }
          }
        }
        dynamic "readiness_probe" {
          for_each = try(container.value.readiness_probe, [])
          content {
            failure_count_threshold = try(readiness_probe.value.failure_count_threshold, 3)
            success_count_threshold = try(readiness_probe.value.success_count_threshold, 2)
            initial_delay           = try(readiness_probe.value.initial_delay, 1)
            interval_seconds        = try(readiness_probe.value.interval_seconds, 10)
            host                    = try(readiness_probe.value.host, null)
            path                    = try(readiness_probe.value.path, null)
            port                    = try(readiness_probe.value.port, 8080)
            transport               = try(readiness_probe.value.transport, "HTTP")
            timeout                 = try(readiness_probe.value.timeout, 1)
            dynamic "header" {
              for_each = try(readiness_probe.value.header, [])
              content {
                name  = try(header.value.name, null)
                value = try(header.value.value, null)
              }
            }
          }
        }
        dynamic "liveness_probe" {
          for_each = try(container.value.liveness_probe, [])
          content {
            failure_count_threshold = try(liveness_probe.value.failure_count_threshold, 3)
            initial_delay           = try(liveness_probe.value.initial_delay, 1)
            interval_seconds        = try(liveness_probe.value.interval_seconds, 10)
            host                    = try(liveness_probe.value.host, null)
            path                    = try(liveness_probe.value.path, null)
            port                    = try(liveness_probe.value.port, 8080)
            transport               = try(liveness_probe.value.transport, "HTTP")
            timeout                 = try(liveness_probe.value.timeout, 1)
            dynamic "header" {
              for_each = try(liveness_probe.value.header, [])
              content {
                name  = try(header.value.name, null)
                value = try(header.value.value, null)
              }
            }
          }
        }
      }
    }

    dynamic "custom_scale_rule" {
      for_each = try(var.settings.template.custom_scale_rules, []) != [] ? var.settings.template.custom_scale_rules : []
      content {
        name             = try(custom_scale_rule.value.name, null)
        custom_rule_type = try(custom_scale_rule.value.custom_rule_type, null)

        metadata = {
          for key, value in custom_scale_rule.value.metadata : key => value
        }
        dynamic "authentication" {
          for_each = try(custom_scale_rule.value.authentication, {}) != {} ? [1] : []

          content {
            secret_name       = try(custom_scale_rule.value.authentication.secret_name, null)
            trigger_parameter = try(custom_scale_rule.value.authentication.trigger_parameter, null)
          }
        }
      }
    }
  }
  lifecycle {
    ignore_changes = [
      tags,
      #template.0.container.0.env
      #template[0].container[0].liveness_probe,
      #template[0].container[0].startup_probe
    ]
  }
}

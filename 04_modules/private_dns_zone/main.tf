resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = var.tags

  dynamic "soa_record" {
    for_each = var.soa_records

    content {
      email        = soa_record.value.email
      expire_time  = soa_record.value.expire_time
      minimum_ttl  = soa_record.value.minimum_ttl
      refresh_time = soa_record.value.refresh_time
      retry_time   = soa_record.value.retry_time
      ttl          = soa_record.value.ttl
      tags         = soa_record.value.tags
    }
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  for_each              = { for inst in var.virtual_network_links : inst.virtual_network_id => inst }
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = each.value.virtual_network_id
  name                  = upper(format("%s-%s", azurerm_private_dns_zone.private_dns_zone.name, split("/", each.value.virtual_network_id)[length(split("/", each.value.virtual_network_id)) - 1]))
  registration_enabled  = try(each.value.registration_enabled, false)
  tags                  = var.tags
  depends_on = [
    azurerm_private_dns_zone.private_dns_zone
  ]

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_dns_a_record" "a_record" {
  for_each            = { for records in var.records : records.name => records }
  name                = each.value.name
  zone_name           = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.records
}

resource "azurerm_private_dns_txt_record" "txt_records" {
  for_each            = { for tr in var.txt_records : tr.name => tr }
  name                = each.value.name
  zone_name           = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  record {
    value = each.value.value
  }
}

resource "azurerm_private_dns_cname_record" "cname_records" {
  for_each            = { for cr in var.cname_records : cr.name => cr }
  name                = each.value.name
  zone_name           = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  record              = each.value.record
}
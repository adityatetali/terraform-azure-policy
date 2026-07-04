resource "azurerm_policy_definition" "this" {
  for_each = var.policy_definitions

  name         = each.key
  policy_type  = each.value.policy_type
  mode         = each.value.mode
  display_name = each.value.display_name
  description  = each.value.description
  metadata     = each.value.metadata
  policy_rule  = each.value.policy_rule
  parameters   = each.value.parameters

  management_group_id = can(regex("managementGroups", var.scope_id)) ? var.scope_id : null
}

resource "azurerm_policy_set_definition" "this" {
  for_each = var.policy_set_definitions

  name                    = each.key
  policy_type             = each.value.policy_type
  display_name            = each.value.display_name
  description             = each.value.description
  metadata                = each.value.metadata
  parameters              = each.value.parameters
  policy_definition_group = each.value.policy_definition_group
  policy_definitions      = each.value.policy_definitions

  management_group_id = can(regex("managementGroups", var.scope_id)) ? var.scope_id : null

  depends_on = [azurerm_policy_definition.this]
}

resource "azurerm_management_group_policy_assignment" "this" {
  for_each = { for k, v in var.policy_assignments : k => v if can(regex("managementGroups", var.scope_id)) }

  name                 = each.key
  management_group_id  = var.scope_id
  policy_definition_id = each.value.policy_definition_id
  display_name         = each.value.display_name
  description          = each.value.description
  enforce              = each.value.enforce
  parameters           = each.value.parameters
  location             = each.value.location

  dynamic "identity" {
    for_each = each.value.identity_type != null ? [1] : []
    content {
      type = each.value.identity_type
    }
  }

  dynamic "non_compliance_message" {
    for_each = each.value.non_compliance_message != null ? [1] : []
    content {
      content = each.value.non_compliance_message
    }
  }
}

resource "azurerm_subscription_policy_assignment" "this" {
  for_each = { for k, v in var.policy_assignments : k => v if can(regex("subscriptions", var.scope_id)) && !can(regex("resourceGroups", var.scope_id)) }

  name                 = each.key
  subscription_id      = var.scope_id
  policy_definition_id = each.value.policy_definition_id
  display_name         = each.value.display_name
  description          = each.value.description
  enforce              = each.value.enforce
  parameters           = each.value.parameters
  location             = each.value.location

  dynamic "identity" {
    for_each = each.value.identity_type != null ? [1] : []
    content {
      type = each.value.identity_type
    }
  }
}

resource "azurerm_resource_group_policy_assignment" "this" {
  for_each = { for k, v in var.policy_assignments : k => v if can(regex("resourceGroups", var.scope_id)) }

  name                 = each.key
  resource_group_id    = var.scope_id
  policy_definition_id = each.value.policy_definition_id
  display_name         = each.value.display_name
  description          = each.value.description
  enforce              = each.value.enforce
  parameters           = each.value.parameters
  location             = each.value.location

  dynamic "identity" {
    for_each = each.value.identity_type != null ? [1] : []
    content {
      type = each.value.identity_type
    }
  }
}

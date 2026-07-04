output "policy_definition_ids" {
  value = { for k, v in azurerm_policy_definition.this : k => v.id }
}

output "policy_set_definition_ids" {
  value = { for k, v in azurerm_policy_set_definition.this : k => v.id }
}

output "management_group_assignment_ids" {
  value = { for k, v in azurerm_management_group_policy_assignment.this : k => v.id }
}

output "subscription_assignment_ids" {
  value = { for k, v in azurerm_subscription_policy_assignment.this : k => v.id }
}

output "resource_group_assignment_ids" {
  value = { for k, v in azurerm_resource_group_policy_assignment.this : k => v.id }
}
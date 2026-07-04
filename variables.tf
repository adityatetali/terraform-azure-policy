variable "scope_id" {
  description = "Resource ID of the scope to apply policy/assignment to (management group, subscription, or resource group)"
  type        = string
}

variable "policy_definitions" {
  description = "Map of custom policy definitions to create"
  type = map(object({
    display_name = string
    description  = optional(string, "")
    policy_type  = optional(string, "Custom")
    mode         = optional(string, "All")
    metadata     = optional(string, null)
    policy_rule  = string                 # JSON string
    parameters   = optional(string, null) # JSON string
  }))
  default = {}
}

variable "policy_set_definitions" {
  description = "Map of custom initiative (policy set) definitions"
  type = map(object({
    display_name            = string
    description             = optional(string, "")
    policy_type             = optional(string, "Custom")
    metadata                = optional(string, null)
    parameters              = optional(string, null)
    policy_definition_group = optional(string, null)
    policy_definitions      = string # JSON array string referencing definition IDs
  }))
  default = {}
}

variable "policy_assignments" {
  description = "Map of policy/initiative assignments"
  type = map(object({
    policy_definition_id   = string
    display_name           = string
    description            = optional(string, "")
    enforce                = optional(bool, true)
    parameters             = optional(string, null)
    identity_type          = optional(string, null) # "SystemAssigned" if remediation needed
    location               = optional(string, null) # required if identity_type set
    non_compliance_message = optional(string, null)
  }))
  default = {}
}

variable "custom_role_definitions" {
  description = "Map of custom role definitions to create, keyed by a unique role key. Referenced from assignments via custom_role_key."
  type = map(object({
    name        = string
    scope       = string
    description = optional(string)
    permissions = object({
      actions          = optional(list(string), [])
      not_actions      = optional(list(string), [])
      data_actions     = optional(list(string), [])
      not_data_actions = optional(list(string), [])
    })
    assignable_scopes = list(string)
  }))
  default = {}
}

variable "assignments" {
  description = "Map of role assignments, keyed by a unique assignment key. Exactly one of role_definition_name, role_definition_id or custom_role_key must be set."
  type = map(object({
    scope                = string
    role_definition_name = optional(string)
    role_definition_id   = optional(string)
    custom_role_key      = optional(string)
    principal_id         = string
    principal_type       = optional(string)
    condition            = optional(string)
    condition_version    = optional(string)
    description          = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.assignments :
      length(compact([v.role_definition_name, v.role_definition_id, v.custom_role_key])) == 1
    ])
    error_message = "Each assignment must set exactly one of role_definition_name, role_definition_id or custom_role_key."
  }
}

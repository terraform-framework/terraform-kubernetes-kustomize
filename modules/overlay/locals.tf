locals {
  // Object that satifies the `resource_name` and
  // `tag_name` nested account attributes. This is
  // used as a default value when it's not present
  default_format = {
    format = "%s"
  }

  // Object that satifies the `build` and `deployment`
  // nested account attributes. This is used as a default
  // value when it's not present
  default_name = {
    name = null
  }

  // If an account module instance isn't passed in
  // we'll just set it to an empty map
  account = coalesce(var.account, {})

  // Build is taken from account module passed in
  // or is otherwise set to a null value
  build = coalesce(
    lookup(local.account, "build", local.default_name),
    local.default_name,
  )

  // Deployment is taken from account module passed in
  // or is otherwise set to a null value
  deployment = coalesce(
    lookup(local.account, "deployment", local.default_name),
    local.default_name,
  )

  // Resource is taken from account module passed in
  // or is otherwise set to the %s format string
  resource_name = coalesce(
    lookup(local.account, "resource_name", local.default_format),
    local.default_format,
  )

  // Tag name is taken from account module passed in
  // or is otherwise set to the %s format string
  tag_name = coalesce(
    lookup(local.account, "tag_name", local.default_format),
    local.default_format,
  )

  // Tags are taken from account module or is
  // otherwise an empty map
  tags = coalesce(lookup(local.account, "tags", {}), {})

  // These tags are (possibly) set by the account module
  // but differ depending on the invoking user context.
  // As the Kustomize doesn't have the ability to suitably
  // ignore certain labels in state drift, we ignore for now.
  blacklisted_tags = [
    "CreatedActor",
    "UpdatedActor",
  ]
}

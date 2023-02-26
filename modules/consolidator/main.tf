// Apply namespace and CRDs
resource "kustomization_resource" "p1" {
  for_each = toset(local.priority1_ids)

  manifest = (
    contains(["_/Secret"], regex(local.group_regex, each.value)["group_kind"])
    ? sensitive(local.manifests[each.value])
    : local.manifests[each.value]
  )
}

// Applies all resources not handled by `p1` and `p3`
resource "kustomization_resource" "p2" {
  for_each = toset(local.priority2_ids)

  manifest = (
    contains(["_/Secret"], regex(local.group_regex, each.value)["group_kind"])
    ? sensitive(local.manifests[each.value])
    : local.manifests[each.value]
  )

  depends_on = [
    kustomization_resource.p1,
  ]
}

// Applies mutating and validating webooks
resource "kustomization_resource" "p3" {
  for_each = toset(local.priority3_ids)

  manifest = (
    contains(["_/Secret"], regex(local.group_regex, each.value)["group_kind"])
    ? sensitive(local.manifests[each.value])
    : local.manifests[each.value]
  )

  depends_on = [
    kustomization_resource.p2,
  ]
}

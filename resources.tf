locals {
  // Regex for finding all `Kind`s in manifests
  group_regex = "(?P<group_kind>.*/.*)/.*/.*"
}

// Apply namespace and CRDs
resource "kustomization_resource" "first" {
  for_each = data.kustomization_overlay.this.ids_prio[0]

  manifest = (
    contains(["_/Secret"], regex(local.group_regex, each.value)["group_kind"])
    ? sensitive(data.kustomization_overlay.this.manifests[each.value])
    : data.kustomization_overlay.this.manifests[each.value]
  )
}

// Applies all resources not handled by `first` and `third`
resource "kustomization_resource" "second" {
  for_each = data.kustomization_overlay.this.ids_prio[1]

  manifest = (
    contains(["_/Secret"], regex(local.group_regex, each.value)["group_kind"])
    ? sensitive(data.kustomization_overlay.this.manifests[each.value])
    : data.kustomization_overlay.this.manifests[each.value]
  )

  depends_on = [
    kustomization_resource.first,
  ]
}

// Applies mutating and validating webooks
resource "kustomization_resource" "third" {
  for_each = data.kustomization_overlay.this.ids_prio[2]

  manifest = (
    contains(["_/Secret"], regex(local.group_regex, each.value)["group_kind"])
    ? sensitive(data.kustomization_overlay.this.manifests[each.value])
    : data.kustomization_overlay.this.manifests[each.value]
  )

  depends_on = [
    kustomization_resource.second,
  ]
}
